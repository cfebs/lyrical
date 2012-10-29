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
  links.each do |link|
    link_text = link[:text]
    youtube_link = get_youtube_links(link_text)[0]
    if link
      youtube_links << youtube_link[:href]
    end
  end

  @links = youtube_links.uniq
  erb :search_result, :layout => false

end

def get_youtube_links(q)
  Youtube.new().get_links(q)
end

# Opens the google search page and gets the h3 links
def get_google_links(q)
  Google.new().get_links(q)
end
