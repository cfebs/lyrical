require 'sinatra'
require 'net/http'
require 'uri'
require 'open-uri'
require 'nokogiri'

get '/' do
  erb :index
end

get '/search/:query' do
  uri = prepare_uri(params[:query])
  links = get_google_links(uri)
  youtube_links = []
  links.each do |link|
    uri = prepare_youtube_uri(link[:text])
    youtube_link = get_youtube_links(uri)[0]
    if link
      youtube_links << youtube_link[:href]
    end
  end
  @links = youtube_links.uniq
  erb :search_result, :layout => false
end

##
# remove common lyric site names
##
def remove_lyrics(str)
  #return str
  str = str.gsub(/\s*youtube\s*/i, '')
  #eLyrics.net
  str = str.gsub(/\s*elyrics\.net/i, '')
  # Lyric Meanings
  str = str.gsub(/\s*lyric[s]?\s*meaning[s]?/i, '')
  # lyric freak.com
  str = str.gsub(/\s*freak\.com/i, '')
  # song freak.com
  str = str.gsub(/song\s*freak\.com/i, '')
  # metro lyrics
  str = str.gsub(/metro\s*lyric[s]?/i, '')
  str = str.gsub(/lyric[s]/i, '')
end

##
# prepares a google uri
##
def prepare_uri(str)
  if !(/lyric[s]/i.match(str))
    str = "#{str} lyrics"
  end

  str = URI.escape(str)
  return "http://www.google.com/search?q=#{str}"
end

def prepare_youtube_uri(str)
  str = URI.escape(str)
  return "http://www.youtube.com/results?search_query=#{str}"
end

def get_youtube_links(uri)
  html = open(uri)
  doc = Nokogiri.HTML(html)
  search = doc.css('#results-main-content')[0]
  if !search
    return []
  end
  # nice end for a lite search
  # return search.to_s
  links = []
  search.css('li.result-item-video h3 a').each do |link|
    text = clean_text(link.text)
    links << {
      :href => link.attr('href').gsub(/\/*watch\?v=/i, '')
    }
  end
  return links
end

##
# Opens the google search page and gets the h3 links
##
def get_google_links(uri)
  html = open(uri)
  doc = Nokogiri.HTML(html)
  doc.css('style, script, img, objecft, embed, iframe, canvas').remove
  search = doc.css('#search')[0]
  # nice end for a lite search
  # return search.to_s
  links = []
  search.css('li.g h3 a').each do |link|
    text = clean_text(link.text)
    links << {
      :href => link.attr('href'),
      :text => remove_lyrics(text).downcase.strip}
  end

  return links[0, 4]
end

##
# remove cruddy characters in link text
##
def clean_text(str)
  encoding_options = {
    :invalid           => :replace,  # Replace invalid byte sequences
    :undef             => :replace,  # Replace anything not defined in ASCII
    :replace           => '',        # Use a blank for those replacements
    :universal_newline => true       # Always break lines with \n
  }
  str.encode!(Encoding.find('ASCII'), encoding_options)
end
