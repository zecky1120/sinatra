require 'sinatra'
require 'sinatra/reloader'
require 'json'


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



