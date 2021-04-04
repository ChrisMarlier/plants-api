require 'open-uri'
class PostsController < ApplicationController
	before_action :firebase_verification, :get_user#, except: :create

	def index
		posts = Post.order('id DESC').page(index_params)

		render :json => {:posts => posts.as_json, :meta => {:total_page => posts.total_pages, :current_page => posts.current_page}},:status => 200
	end

	def create

		if params[:post].has_key?(:image)
			name = @user.id.to_s + '-' + Time.now.to_i.to_s + '.jpg'

			if object_uploaded?($BUCKET_FOLDER + name, params[:post][:image].path)

			  	post = Post.create!(post_params.merge(user: @user).merge(image: name))
			else
		    	render :json => {:response => 'Error while uploading image' },:status => 502
		  	end
		else
			post = Post.create!(post_params.merge(user: @user))
		end

		render :json => {:post => post.as_json}, :status => 200
	end

	def destroy
		post = Post.where(user: @user).find_by_id(params[:id])

		if post
			if !post.image.nil?
				$S3_CLIENT.delete_object({
			    bucket: $BUCKET_NAME,
			    key: $BUCKET_FOLDER + post.image,
			  	})
			end

			post.destroy!
			render :status => 204
		else
			render :json => {:response => 'Error while deleting post' },:status => 502
		end
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

	def index_params
		params.require(:page)
	end

end
