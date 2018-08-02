class UsersController < ApplicationController

	get "/signup" do
    	if   !!session[:user_id]
	    	redirect '/gimojis'
	    end
	    erb :'users/signup'
	end

    post "/signup" do
   
    	if !!session[:user_id]
    		redirect '/gimojis'
    	end
        if params[:fullname] == ""
            redirect "/signup"
        end
    	if params[:username] == ""
    		redirect "/signup"
    	end
    	if params[:email] == ""
    		redirect "/signup"
    	end
    	if params[:password] == ""
    		redirect "/signup"
    	end
    	@user = User.create(:username => params[:username], :email => params[:email], :password => params[:password])
    	if @user
    		session[:user_id] = @user.id
 			redirect "/gimojis"
    	else
    		redirect "/login"
 		end
	end

    get '/account' do
    	@user = User.find(session[:user_id])
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
   		@user = find_by_slug(params[:slug])
   		if !!session[:user_id]
   		    redirect to "/users/#{user.slug}"
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