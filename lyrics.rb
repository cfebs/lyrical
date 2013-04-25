require 'sinatra'
require 'rdiscount'
require './lib/lyric_search'

get '/' do
  erb :index
end

get '/search/:query' do
  query = params[:query]
  links = get_google_links(query)

  youtube_links = []
  title_map = {}

  links.each do |link|
    link_text = link[:text]
    youtube_link = get_youtube_links(link_text)[0]

    if link and youtube_link
      video_id = youtube_link[:id]
      title = truncate_title(youtube_link[:title])
      youtube_links << video_id
      title_map[video_id] = title
    end

  end

  @links = []
  youtube_links.uniq.each do |id|
    @links << { :id => id, :title => title_map[id] }
  end
  erb :search_result, :layout => false

end

def get_youtube_links(q)
  Youtube.new().get_links(q)
end

# Opens the google search page and gets the h3 links
def get_google_links(q)
  Google.new().get_links(q)
end

def truncate_title(t, l=50)
  if t.length > l
    t[0, 60] + ' ...'
  else
    t
  end
end
