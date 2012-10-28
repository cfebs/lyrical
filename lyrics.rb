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
  links.to_s
end

##
# remove common lyric site names
##
def remove_lyrics(str)
  str = str.gsub(/song\s*freak\.com/i, '')
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
    links << remove_lyrics(text)
  end

  return links
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
