# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'securerandom'
# require_relative 'memo'

TABLE_NAME = 'memos'
DB_NAME = 'memo_app'
CONN = PG::Connection.new(dbname: "#{DB_NAME}")

def build_id
  SecureRandom.hex
end

def memos
  query = "SELECT * FROM #{TABLE_NAME}"
  CONN.exec(query)
end

def get_memo(id)
  memos.find { |memo| memo['id'] == id }
end

def create_memo(id, title, content, created_at)
  query = "INSERT INTO #{TABLE_NAME}(id, title, content, created_at) VALUES ($1, $2, $3, $4);"
  CONN.exec_params(query, [id, title, content, created_at])
end

def update_memo(id, title, content)
  query = "UPDATE #{TABLE_NAME} SET title = $1, content = $2 WHERE id = $3;"
  CONN.exec_params(query, [title, content, id])
end

def delete_memo(id)
  query = "DELETE FROM #{TABLE_NAME} WHERE id = $1;"
  CONN.exec_params(query, [id])
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
  id = build_id
  title = params['title']
  content = params['content']
  created_at = Time.now
  create_memo(id, title, content, created_at)
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
  title = params['title']
  content = params['content']
  update_memo(id, title, content)
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
