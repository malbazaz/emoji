	require 'sinatra/base'
	require 'rack-flash'

class GimojisController < ApplicationController
	enable :sessions
    use Rack::Flash
	get '/gimojis' do

		if !!session[:user_id]
			@user = User.find_by_id(session[:user_id])
			#binding.pry
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
			flash[:message] = "Error. You have not filled the form properly to create a Gimoji. Please do so."
			redirect to '/gimojis/new'
		else
			@gimoji = Gimoji.create(name: params[:gimoji][:name], tag: params[:gimoji][:tag], user_id: session[:user_id])
			#@gimoji.user_id = session[:user_id]
			#@gimoji.save
			if params[:gimoji][:new_emotion]
				@emotion = Emotion.create(name: params[:gimoji][:new_emotion])
				@gimoji.emotions << @emotion
				@gimoji.save
			end
			if  params[:gimoji][:emotion_ids]
				params[:gimoji][:emotion_ids].each do |emotion_id|
					@gimoji.emotions << Emotion.find_by_id(emotion_id)
					@gimoji.save 
				end
			end
			flash[:message] = "Successfully created Gimoji."
			redirect to "/gimojis/#{@gimoji.slug}"
 		end
 	end

get '/gimojis/:slug' do

	if !!session[:user_id]
		@gimoji = Gimoji.find_by_slug(params[:slug])
		#binding.pry
		erb :'gimojis/show'
	else
		redirect '/login'
	end
end


patch '/gimojis/:slug/gift' do 
	@gimoji=Gimoji.find_by_slug(params[:slug])
	#binding.pry
	if !!session[:user_id] && @gimoji.user_id == session[:user_id]
		@gimoji.gift(params[:fullname])
		flash[:message] = "Successfully gifted the Gimoji."
		redirect to "/gimojis"
	else 
		flash[:message] = "You don't own the Gimoji. You can't gift it."
		redirect to '/gimojis'
	end 
end 

get '/gimojis/:slug/edit' do
	#binding.pry
	@gimoji = Gimoji.find_by_slug(params[:slug])
	if !!session[:user_id] && session[:user_id] == @gimoji.user_id
		erb :'gimojis/edit'
	else
		redirect '/login'
	end
end

patch '/gimojis/:slug' do
	if params[:gimoji][:name] == "" || params[:gimoji][:tag] == ""
		flash[:message] = "Error. You have not filled the form properly to edit your Gimoji. Please do so by having a name and tag."
		redirect "/gimojis/#{params[:slug]}/edit"
	end
	@gimoji = Gimoji.find_by_slug(params[:slug])
	@gimoji.name = params[:gimoji][:name]
	@gimoji.save
	if params[:gimoji][:emotion_ids]
		params[:gimoji][:emotion_ids].each do |emotion_id|
			@emotion = Emotion.find_by_id(emotion_id)
			#binding.pry	
			if !@gimoji.emotions.include?(@emotion)
				@gimoji.emotions << @emotion 
				@gimoji.save
			end 
		end 
	end
	if params[:gimoji][:new_emotion]
		@emotion = Emotion.create(name: params[:gimoji][:new_emotion])
		@gimoji.emotions << @emotion 
		@gimoji.save
	end
	@gimoji.save
	erb :'gimojis/show'
end

delete '/gimojis/:slug/delete' do
    #binding.pry
    @gimoji = Gimoji.find_by_slug(params[:slug])
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
