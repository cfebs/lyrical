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
  doc.css('#search')[0].to_s
end
