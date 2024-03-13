require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom'

# ------------------------- method
def files
  Dir.glob('./data/*.json')
end

def get_memo(file_path)
  File.open(file_path) do |file|
    JSON.load(file)
  end
end

def memo
  "./data/#{params['id']}.json"
end

# ------------------------- routing
# top
get '/' do
  redirect '/memos'
end

get '/memos' do
  memos = files.map {|file| get_memo(file)}
  @memos = memos.sort_by {|f| f['time']}
  @title = 'トップ'
  erb :index
end

# new
get '/memos/new' do 
  @title = '入力画面'
  erb :new
end

# create
post '/memos' do
  memo = {'id' => SecureRandom.hex(10), 'title' => params['title'], 'content' => params['content'], 'time' => Time.now }
  File.open("./data/#{memo['id']}.json", 'w') do |f|
    JSON.dump(memo, f)
  end
  redirect "/memos"
end
