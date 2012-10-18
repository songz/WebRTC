require 'rubygems'
require 'sinatra'

get '/' do
  erb :index
end

get '/subscriber' do
  erb :subscriber
end

def printa a
  p "========"
  p "========"
  p "========"
  p a
  p "========"
  p "========"
  p "========"
end
