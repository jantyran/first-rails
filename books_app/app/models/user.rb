class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,:omniauthable
  has_one_attached :avatar


   def self.from_omniauth(auth)
	  where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
	    user.email = auth.info.email
	    user.password = Devise.friendly_token[0,20]
	    user.name = auth.info.name   # assuming the user model has a name
	    user.image = auth.info.image # assuming the user model has an image
	    # If you are using confirmable and the provider(s) you use validate emails, 
	    # uncomment the line below to skip the confirmation emails.
	    # user.skip_confirmation!
	  end
	end

	def self.find_for_oauth(auth)
	    user = User.where(uid: auth.uid, provider: auth.provider).first

	    unless user
	      user = User.create(
	        uid:      auth.uid,
	        provider: auth.provider,
	        email:    User.dummy_email(auth),
	        password: Devise.friendly_token[0, 20]
	      )
	    end

	    user
  	end

	private
		def user_params
			params.require(:user).permit(:email, :password, :avatar)
		end

		def self.dummy_email(auth)
		    "#{auth.uid}-#{auth.provider}@example.com"
	    end
end
