require 'sinatra'
require 'rdiscount'
require './lib/link_fetcher'

get '/' do
  erb :index
end

get '/search/:query' do

  @links = LinkFetcher.new(params[:query]).get_links
  erb :search_result, :layout => false

end

