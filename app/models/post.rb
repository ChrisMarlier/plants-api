class Post < ApplicationRecord
	belongs_to :user

	def as_json(*args)
	    {
	        "body": self.body,
		    "created_at": self.created_at,
		    "id": self.id,
		    "image": !self.image.nil? ? $BUCKET_URL + $BUCKET_FOLDER + self.image : nil,
		    "updated_at": self.updated_at,
		    "user_id": self.user_id,
		    "youtube_id": !self.youtube_id.nil? ? self.youtube_id : nil,
		    "user": self.user
	    }
	end

end
