class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # and
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable, :validatable,
         :confirmable,
         :lockable,
         :timeoutable,
         :trackable,
         :omniauthable, omniauth_providers: [:facebook, :google_oauth2]

  has_one :user_property

  def self.find_oauth(auth)
    uid = auth.uid
    provider = auth.provider
    snscredential = SnsCredential.where(uid: uid, provider: provider).first
    if snscredential.present?
      user = User.where(id: snscredential.user_id).first
    else
      user = User.where(email: auth.info.email).first
      if user.present?
        SnsCredential.create(
            uid: uid,
            provider: provider,
            user_id: user.id
        )
      else
        user = User.create(
            nickname: auth.info.name,
            email: auth.info.email,
            password: Devise.friendly_token[0, 20]
        )
        SnsCredential.create(
            uid: uid,
            provider: provider,
            user_id: user.id
        )
      end
    end
    return user
  end
end
