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

# show
get '/memos/:id' do
  @memo = get_memo(memo)
  @title = @memo['title']
  erb :show
end

# edit
get '/memos/:id/edit' do
  @memo = get_memo(memo)
  @title = "編集 - " + @memo['title']
  erb :edit
end

post '/memos/:id' do
  memo = {'id' => params['id'], 'title' => params['title'], 'content' => params['content']}
  File.open("./data/#{memo['id']}.json", 'w') do |f|
    JSON.dump(memo, f)
  end
  redirect "/memos/#{memo['id']}"
end