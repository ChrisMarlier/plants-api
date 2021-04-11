class UsersController < ApplicationController
	before_action :firebase_verification, :get_user

	def show
		render json: {:profile => {pseudo: @user.pseudo}},:status => 200
	end

	def update
		@user.update!(update_params)

		render :json => {:profile => {pseudo: @user.pseudo} },:status => 200
	end


	def update_params
  		params.require(:profile).permit(:pseudo)
	end


end
