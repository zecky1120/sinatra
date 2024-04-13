# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom'

def build_id
  SecureRandom.hex
end

def memos
  Dir.glob('./data/*').map { |memo| JSON.load_file(memo) }
end

def path(id)
  "./data/#{id}.json"
end

def get_memo(id)
  JSON.load_file(path(id)) if File.exist?(path(id))
end

def save_memo(id, memo)
  File.open(path(id), 'w') { |file| JSON.dump(memo, file) }
end

def delete_memo(id)
  File.delete(path(id))
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = memos.sort_by { |memo| memo['created_at'] }
  @title = 'トップ'
  erb :index
end

get '/memos/new' do
  @title = '入力画面'
  erb :new
end

post '/memos' do
  memo = { 'id' => build_id, 'title' => params['title'], 'content' => params['content'], 'created_at' => Time.now }
  save_memo(memo['id'], memo)
  redirect "/memos"
end

get '/memos/:id' do |id|
  @memo = get_memo(id)
  if @memo
    @title = @memo['title']
    erb :show
  else
    redirect 'not_found'
  end
end

get '/memos/:id/edit' do |id|
  @memo = get_memo(id)
  @title = "編集 - #{@memo['title']}"
  erb :edit
end

patch '/memos/:id' do |id|
  memo = get_memo(id)
  memo['title'] = params['title']
  memo['content'] = params['content']
  save_memo(id, memo)
  redirect "/memos/#{id}"
end

delete '/memos/:id' do |id|
  delete_memo(id)
  redirect '/memos'
end

not_found do
  @title = 'ファイルは存在しません'
  erb :not_found
end
