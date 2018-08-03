class GimojisController < ApplicationController

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
		redirect to "/gimojis/#{@gimoji.slug}"
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
