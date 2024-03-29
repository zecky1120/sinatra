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
  File.open(path(id)) { |file| JSON.load_file(file) } if File.exist?(path(id))
end

def create_memo(memo)
  File.open("./data/#{memo['id']}.json", 'w') { |file| JSON.dump(memo, file) }
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
  create_memo(memo)
  redirect '/memos'
end

get '/memos/:id' do |id|
  @memo = get_memo(id)
  @memo.nil? ? (redirect 'not_found') : @memo
  @title = @memo['title']
  erb :show
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
  create_memo(memo)
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
