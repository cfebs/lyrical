require 'sinatra'
require 'open-uri'
require 'nokogiri'

get '/' do
  erb :index
end

get '/search/:query' do
  html = open("http://www.google.com/search?q=#{params[:query]}")
  doc = Nokogiri.HTML(html)
  doc.css('style, script, img, objecft, embed, iframe, canvas').remove
  doc.css('#search')[0].to_s
end
