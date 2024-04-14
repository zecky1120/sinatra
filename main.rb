# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'securerandom'
require_relative 'memo'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = Memo.all
  @title = 'トップ'
  erb :index
end

get '/memos/new' do
  @title = '入力画面'
  erb :new
end

post '/memos' do
  memo = { 'title' => params['title'], 'content' => params['content'], 'created_at' => Time.now }.values
  Memo.create(memo)
  redirect '/memos'
end

get '/memos/:id' do |id|
  @memo = Memo.find(id)
  if @memo
    @title = @memo['title']
    erb :show
  else
    redirect 'not_found'
  end
end

get '/memos/:id/edit' do |id|
  @memo = Memo.find(id)
  @title = "編集 - #{@memo['title']}"
  erb :edit
end

patch '/memos/:id' do |id|
  memo = Memo.find(id)
  memo['title'] = params['title']
  memo['content'] = params['content']
  Memo.update(memo.values_at('id', 'title', 'content'))
  redirect "/memos/#{id}"
end

delete '/memos/:id' do |id|
  Memo.delete(id)
  redirect '/memos'
end

not_found do
  @title = 'ファイルは存在しません'
  erb :not_found
end
