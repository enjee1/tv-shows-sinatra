require 'sinatra'
require "sinatra/reloader" if development? || test?
require 'sinatra/flash'
require 'sinatra/activerecord'
require "pry" if development? || test?

require_relative "app/models/television_show"

set :bind, '0.0.0.0'  # bind to all interfaces

configure do
  set :views, 'app/views'
end

enable :sessions

Dir[File.join(File.dirname(__FILE__), 'app', '**', '*.rb')].each do |file|
  require file
  if development? || test?
    also_reload file
  end
end

get "/" do
  redirect "/television_shows"
end

get "/television_shows" do
  @shows = TelevisionShow.all
  erb :index
end

get "/television_shows/new" do
  @show = TelevisionShow.new
  erb :new
end

get "/television_shows/:id" do
  @show = TelevisionShow.find(params[:id])
  @end_year = @show.ending_year != nil ? @show.ending_year : "Show is still running."
  erb :show
end

post "/television_shows" do
  @show = TelevisionShow.new(params[:television_show])

  if @show.save
    redirect "/television_shows"
  else
    erb :new
  end
end
