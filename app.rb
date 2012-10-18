require 'rubygems'
require 'sinatra'

get '/' do
  erb :index
end

get '/subscriber' do
  erb :subscriber
end

get '/test' do
  erb :test
end

get '/test2' do
  erb :test2
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
