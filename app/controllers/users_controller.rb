class UsersController < ApplicationController
	before_action :firebase_verification

	def show

		get_user

		render json: {:profile => {pseudo: @user.pseudo}},:status => 200
	end

	def update
		get_user

		@user.update(update_params)

		render :json => {:profile => {pseudo: @user.pseudo} },:status => 200
	end


	def update_params
  		params.require(:profile).permit(:pseudo)
	end


end
