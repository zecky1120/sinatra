# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom'

# def get_json_files
#   Dir.glob('./data/*')
# end

def get_memos
  Dir.glob('./data/*').map { |memo| JSON.load_file(memo) }
end

def get_memo(file_path)
  File.open(file_path) do |file|
    JSON.load_file(file)
  end
end

def get_file_path
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
  @memos = get_memos.sort_by { |memo| memo['created_at'] }
  @title = 'トップ'
  erb :index
end

get '/memos/new' do
  @title = '入力画面'
  erb :new
end

post '/memos' do
  memo = { 'id' => SecureRandom.hex, 'title' => params['title'], 'content' => params['content'], 'created_at' => Time.now }
  File.open("./data/#{memo['id']}.json", 'w') do |f|
    JSON.dump(memo, f)
  end
  redirect '/memos'
end

get '/memos/:id' do
  File.exist?(memo) ? @memo = get_memo(memo) : (redirect to('not_found'))
  @title = @memo['title']
  erb :show
end

get '/memos/:id/edit' do
  @memo = get_memo(memo)
  @title = "編集 - #{@memo['title']}"
  erb :edit
end

post '/memos/:id' do
  title = params['title']
  content = params['content']
  created_at = memo['created_at']
  memo = { 'id' => params['id'], 'title' => title, 'content' => content, 'created_at' => created_at }
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
  @title = 'ファイルは存在しません'
  erb :not_found
end

