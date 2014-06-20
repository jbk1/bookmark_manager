require 'sinatra'
require 'data_mapper'
require 'rack-flash'

env = ENV["RACK_ENV"] || "development"
enable :sessions
set :session_secret, 'super secret'
use Rack::Flash




# we're telling datamapper to use a postgres database on localhost. 
# The name will be "bookmark_manager_test" or "bookmark_manager_development" 
# depending on the environment
DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")

require './lib/link' # this needs to be done after datamapper is initialised
require './lib/user.rb'

# After declaring your models, you should finalise them
DataMapper.finalize

# However, how database tables don't exist yet. Let's tell datamapper to create them
DataMapper.auto_upgrade!
# auto_upgrade makes non-destructive changes. It your tables don't exist, they will be created
# but if they do and you changed your schema (e.g. changed the type of one of the properties)
# they will not be upgraded because that'd lead to data loss.
# To force the creation of all tables as they are described in your models, even if this
# leads to data loss, use auto_migrate:
# DataMapper.auto_migrate!
# Finally, don't forget that before you do any of that stuff, you need to create a database first.

get '/' do
  @links = Link.all
  erb :index
end

post '/links' do
	url = params["url"]
	title = params["title"]
	tags = params["tags"].split(" ").map do |tag|
		# this will either find this tag or create
		# it if it doesn't exist already
		Tag.first_or_create(:text => tag)
	end
Link.create(:url => url, :title => title, :tags => tags)
redirect to('/')
end

get '/tags/:text' do
	tag = Tag.first(:text => params[:text])
	@links = tag ? tag.links : []
	erb :index
end
 # surely this completely overwrites @link variable and really we just want to be doing an equality comparison? 
# if @links = tag
# 	tag.links
# else
# 	[]
# end

# @links = (tag ? tag.links : []) ?????

get '/new' do
	@user = User.new
	erb :"new"
end

post '/users' do
	@user = User.new(:email => params[:email],
					:password => params[:password],
					:password_confirmation => params[:password_confirmation])
	if @user.save
		session[:user_id] = @user.id
		redirect to('/')
	else
		flash[:notice] = "Sorry, your passwords don't match"
		erb :"/new"
	end
end

# this is a sinatra helper method.
helpers do

def current_user  
    @current_user ||=User.get(session[:user_id]) if session[:user_id]
end

end


