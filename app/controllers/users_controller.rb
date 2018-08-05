require 'sinatra/base'
require 'rack-flash'

class UsersController < ApplicationController
    enable :sessions
    use Rack::Flash


	get "/signup" do
    	if   !!session[:user_id]
	    	flash[:message] = "You are already logged-in. You didn't need to register. If it's not logged in as you, please log out."
            redirect '/gimojis'
	    end
	    erb :'users/signup'
	end

    post "/signup" do
            #binding.pry
    	if !!session[:user_id]
    		redirect '/gimojis'
    	end
        if params[:fullname] == ""
            redirect "/signup"
        end
    	if params[:username] == "" || User.find_by_username(params[:username])
    		redirect "/signup"
    	end
    	if params[:email] == "" || User.find_by_email(params[:email])
    		redirect "/signup"
    	end
    	if params[:password] == ""
    		redirect "/signup"
    	end
        #binding.pry
    	@user = User.create(fullname: params["fullname"], username: params["username"], email: params["email"], password: params["password"])
    	if @user
    		session[:user_id] = @user.id
 			redirect "/gimojis"
    	else
    		redirect "/login"
 		end
	end

    get '/account' do
        #binding.pry
    	@user = User.find_by_id(session[:user_id])
      	erb :'users/show'
    end


    get "/login" do
    	if !!session[:user_id]
    		redirect "/gimojis"
    	end
    	erb :'users/login'
    end

    post "/login" do
      
    	if !!session[:user_id]
    		redirect "/gimojis"
    	end
    	user = User.find_by(:username => params[:username])
    	if user && user.authenticate(params[:password])
    		session[:user_id] = user.id
    		redirect "/gimojis"
    	else
    		redirect "/login"
    	end
    end

    get '/users/:slug' do
   		@user = User.find_by_slug(params[:slug])
        #binding.pry
   		if !!session[:user_id]
   		    erb :'users/show'
   		else
   			redirect to '/login'
   		end
  	end

    get "/logout" do
    	session.clear
    	redirect "/login"
    end

    post "/logout" do
    	session.clear
    	redirect "/login"
    end

end