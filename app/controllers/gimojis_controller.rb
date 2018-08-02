class GimojisController < ApplicationController

	get '/gimojis' do

	  if !!session[:user_id]
	    @user = User.find_by_id(session[:user_id])
	    erb :'gimojis/gimojis'
	  else
	    redirect '/login'
	  end
	end 

	
end