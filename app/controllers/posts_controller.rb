class PostsController < ApplicationController
	before_action :firebase_verification#, except: :create


	def index
		
		render :json => {:response => 'You did it' },:status => 200
	end

end
