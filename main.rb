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

def get_memo(file_path)
  File.open(file_path) { |file| JSON.load_file(file) }
end

def build_memo(id)
  File.open("./data/#{id}.json") { |file| JSON.load_file(file) }
end

def json_file(id)
  "./data/#{id}.json"
end

def create_memo(memo)
  File.open("./data/#{memo['id']}.json", 'w') { |file| JSON.dump(memo, file) }
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
  File.exist?(json_file(id)) ? @memo = build_memo(id) : (redirect to('not_found'))
  @title = @memo['title']
  erb :show
end

get '/memos/:id/edit' do |id|
  @memo = build_memo(id)
  @title = "編集 - #{@memo['title']}"
  erb :edit
end

post '/memos/:id' do |id|
  title = params['title']
  content = params['content']
  created_at = build_memo(id)['created_at']
  memo = { 'id' => id, 'title' => title, 'content' => content, 'created_at' => created_at }
  create_memo(memo)
  redirect "/memos/#{id}"
end

delete '/memos/:id' do |id|
  File.delete(json_file(id))
  redirect '/memos'
end

not_found do
  @title = 'ファイルは存在しません'
  erb :not_found
end
