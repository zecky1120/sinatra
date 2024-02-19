require 'sinatra'
require 'sinatra/reloader'

get '/' do
  @title = 'トップ'
  erb :index
end

