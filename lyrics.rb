require 'sinatra'
require 'net/http'
require 'uri'
require 'open-uri'
require 'nokogiri'

get '/' do
  erb :index
end

get '/search/:query' do
  q = URI.escape(params[:query])
  uri = "http://www.google.com/search?q=#{q}"
  html = open(uri)
  doc = Nokogiri.HTML(html)
  doc.css('style, script, img, objecft, embed, iframe, canvas').remove
  search = doc.css('#search')[0]
  # nice end for a lite search
  # return search.to_s
  links = []
  search.css('li.g h3 a').each do |link|
    puts link.text
    text = clean_text(link.text)
    puts text
    links << remove_lyrics(text)
  end
  links.to_s
end

def clean_text(str)
  # remove cruddy characters
  encoding_options = {
    :invalid           => :replace,  # Replace invalid byte sequences
    :undef             => :replace,  # Replace anything not defined in ASCII
    :replace           => '',        # Use a blank for those replacements
    :universal_newline => true       # Always break lines with \n
  }
  str.encode!(Encoding.find('ASCII'), encoding_options)
end

def remove_lyrics(str)
  str = str.gsub(/song\s*freak\.com/i, '')
  str = str.gsub(/metro\s*lyric[s]?/i, '')
  str = str.gsub(/lyric[s]/i, '')
end
