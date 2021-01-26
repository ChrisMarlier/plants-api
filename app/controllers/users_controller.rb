class UsersController < ApplicationController
	before_action :firebase_verification

	def show

		user = User.where(firebaseId: @firebase_user["localId"]).first

		if  user == nil then
			user = User.create!(email: @firebase_user["email"], firebaseId: @firebase_user["localId"])
		end

		render json: {:profile => {pseudo: user.pseudo}},:status => 200
	end

	def update
		user = User.where(firebaseId: @firebase_user["localId"]).first

		user.update(update_params)

		render :json => {:profile => {pseudo: user.pseudo} },:status => 200
	end


	def update_params
  		params.require(:profile).permit(:pseudo)
	end


end
