class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable,
  :omniauthable, omniauth_providers: [:facebook]

  def self.from_omniauth(auth)
    if user = User.find_by_email(auth.info.email)
    # if a user in the database already has the email returned by the auth provider, set their provider and uid attributes, and return that user
      user.provider = auth.provider
      user.uid = auth.uid
      user
    else
    # otherwise, have a look to see if a different email address is registered with that provider and uid - return them if they do, otherwise create a new user from the credentials given (with a random password)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      end
    end
  end
end
