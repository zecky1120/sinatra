require 'sinatra'
require 'sinatra/reloader'

get '/' do
  @title = 'トップ'
  erb :index
end

get '/new' do 
  @title = '入力画面'
  erb :new
end