require 'rubygems'
require 'sinatra'

get '/' do
  redirect "/#{Time.now.to_i}"
end

get '/:id' do
  @id = params[:id]
  erb :index
end
