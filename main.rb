require 'sinatra'

get '/' do
  'Hello world!'
end

get "/hello/:name" do
  "hello #{prams[:name]}”
end