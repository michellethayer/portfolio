require 'rubygems'
require 'compass' #must be loaded before sinatra
require 'sinatra'
require 'haml'    #must be loaded after sinatra
require 'coffee-script'

# set sinatra's variables
set :app_file, __FILE__
set :root, File.dirname(__FILE__)
set :views, "views"
set :public, 'static'

configure do
  Compass.add_project_configuration(File.join(Sinatra::Application.root, 'config', 'compass.config'))
end

# at a minimum, the main sass file must reside within the ./views directory. here, we create a ./views/stylesheets directory where all of the sass files can safely reside.
get '/stylesheets/:name.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass(:"stylesheets/#{params[:name]}", Compass.sass_engine_options )
end

get '/coffee/:name.js' do
  coffee :"coffee/#{params[:name]}"  
end

get '/' do
  haml :index, :layout => !request.xhr? 
end

get '/:name' do
  haml :"#{params[:name]}", :layout => !request.xhr? 
end

not_found do
  haml :'404', :layout => false
end

error do 
  haml :'500', :layout => false
end



