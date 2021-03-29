class ApplicationController < ActionController::API

	def firebase_verification

		api_key = "AIzaSyAEg6tenjngzc8Py6fJ0cDaMfPAhZEV3z4"
		url = "https://www.googleapis.com/identitytoolkit/v3/relyingparty/getAccountInfo?key=#{api_key}"

		token = request.headers[:Authorization]

		firebase_verification_call = HTTParty.post(url, headers: { 'Content-Type' => 'application/json' }, body: { 'idToken' => token }.to_json )
		
		if firebase_verification_call.response.code == "200"
			@firebase_user = firebase_verification_call.parsed_response["users"][0]

		else
			render :json => {:response => 'Wrong authentification token' },:status => 401
		end
	end

	def get_user
		@user = User.where(firebaseId: @firebase_user["localId"]).first

		if  @user == nil then
			@user = User.create!(email: @firebase_user["email"], firebaseId: @firebase_user["localId"])
		end
	end

end
