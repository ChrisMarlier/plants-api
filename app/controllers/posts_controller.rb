require 'open-uri'
class PostsController < ApplicationController
	before_action :firebase_verification#, except: :create

	def index
		render :json => {:response => 'You did it' },:status => 200
	end

	def create

		get_user

		if params[:post].has_key?(:image)

			name = @user.id.to_s + '-' + Time.now.to_i.to_s + '.jpg'

			object_key = 'prod/feed/' + name

			if object_uploaded?(object_key, params[:post][:image].path)

			  	post = Post.create!(post_params.merge(user: @user).merge(image: name))
			else
		    	render :json => {:response => 'Error while uploading image' },:status => 502
		  	end
		else
			post = Post.create!(post_params.merge(user: @user))
		end


		render :json => {:post => {id: post.id, body: post.body, youtube_id: post.youtube_id, image: post.image} },:status => 200
	end

	def object_uploaded?(object_key, path)

		image = File.open(open(path), 'rb')

		response = $S3_CLIENT.put_object(
			body: image,
		    bucket: $BUCKET_NAME,
		    key: object_key,
		    acl: 'public-read',
		)

	  	if response.etag
	    	return true
	  	else
		    return false
		end
		rescue StandardError => e
		  return false
		end

	def post_params
  		params.require(:post).permit(:body, :youtube_id, :image)
	end

end
