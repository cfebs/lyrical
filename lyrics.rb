require 'sinatra'
require 'net/http'
require 'uri'

get '/' do
  erb :index
end

get '/search/:query' do
  # TODO nokogiri
  uri = URI.parse("http://www.google.com/search?q=#{params[:query]}")
  response = Net::HTTP.get_response(uri);
  response.body
end
