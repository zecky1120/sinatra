# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom'

def files
  Dir.glob('./data/*')
end

def get_memo(file_path)
  File.open(file_path) do |file|
    JSON.load_file(file)
  end
end

def memo
  "./data/#{params['id']}.json"
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
  memos = files.map { |file| get_memo(file) }
  @memos = memos.sort_by { |f| f['time'] }
  @title = 'トップ'
  erb :index
end

get '/memos/new' do
  @title = '入力画面'
  erb :new
end

post '/memos' do
  memo = { 'id' => SecureRandom.hex, 'title' => params['title'], 'content' => params['content'], 'time' => Time.now }
  File.open("./data/#{memo['id']}.json", 'w') do |f|
    JSON.dump(memo, f)
  end
  redirect '/memos'
end

get '/memos/:id' do
  File.exist?(memo) ? @memo = get_memo(memo) : (redirect to('not_found'))
  @title = @memo['title']
  @id = @memo['id']
  @content = @memo['content']
  erb :show
end

get '/memos/:id/edit' do
  @memo = get_memo(memo)
  @title = "編集 - #{@memo['title']}"
  erb :edit
end

post '/memos/:id' do
  @memo = get_memo(memo)
  memo = { 'id' => params['id'], 'title' => params['title'], 'content' => params['content'], 'time' => @memo['time'] }
  File.open("./data/#{memo['id']}.json", 'w') do |f|
    JSON.dump(memo, f)
  end
  redirect "/memos/#{memo['id']}"
end

delete '/memos/:id' do
  File.delete(memo)
  redirect '/memos'
end

not_found do
  erb :not_found
end
