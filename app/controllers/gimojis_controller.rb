class GimojisController < ApplicationController

	get '/gimojis' do

		if !!session[:user_id]
			@user = User.find_by_id(session[:user_id])
			erb :'gimojis/gimojis'
		else
			redirect '/login'
		end
	end 

	get '/gimojis/new' do
		if !!session[:user_id]
			erb :'gimojis/create'
		else
			redirect '/login'
		end
	end

	post '/gimojis' do

		if params[:gimoji][:name] == "" || params[:gimoji][:tag] == ""
			redirect to '/gimojis/new'
		else
			@gimoji = gimoji.create(name: params[:gimoji][:name], tag: params[:gimoji][:tag])
			@gimoji.user_id = session[:user_id]
			@gimoji.save
			redirect to "/gimojis/#{@gimoji.slug}"
 		end
 	end

get '/gimojis/:slug' do
	if !!session[:user_id]
		@gimoji = gimoji.find_by_id(params[:id])
		erb :'gimojis/show'
	else
		redirect '/login'
	end
end

get '/gimojis/:slug/edit' do
	if !!session[:user_id]
		@gimoji = gimoji.find_by_id(params[:id])
		erb :'gimojis/edit'
	else
		redirect '/login'
	end
end


	
end