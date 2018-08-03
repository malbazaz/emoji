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
			@gimoji = Gimoji.create(name: params[:gimoji][:name], tag: params[:gimoji][:tag])
			@gimoji.user_id = session[:user_id]
			@gimoji.save
			redirect to "/gimojis/#{@gimoji.slug}"
 		end
 	end

get '/gimojis/:slug' do
	if !!session[:user_id]
		@gimoji = Gimoji.find_by_id(params[:id])
		erb :'gimojis/show'
	else
		redirect '/login'
	end
end

get '/gimojis/:slug/edit' do
	if !!session[:user_id]
		@gimoji = Gimoji.find_by_id(params[:id])
		erb :'gimojis/edit'
	else
		redirect '/login'
	end
end

patch '/gimojis/:slug' do
	if params[:gimoji][:name] == "" || params[:gimoji][:tag] == ""
		redirect "/gimojis/#{params[:slug]}/edit"
	end
	@gimoji = Gimoji.find_by_id(params[:id])
	@gimoji.name = params[:gimoji][:name]
	@gimoji.save
	erb :'gimojis/show'
end

delete '/gimojis/:slug/delete' do
    #binding.pry
    @gimoji = Gimoji.find_by_id(params[:id])
    if !session[:user_id]
    	redirect to "/login"
    end
    if @gimoji.user_id == session[:user_id]
    #binding.pry
    	@gimoji.delete
    	redirect to "/gimojis"
	else
		redirect to "/login"
	end
end

end	
