require 'securerandom'
require 'base64'

class User < ApplicationRecord
  has_one_attached :avatar, dependent: :destroy
  has_one :token, dependent: :destroy
  has_one :confirm_email_key, dependent: :destroy
  has_many :hike_events, dependent: :destroy
  after_create :generate_token, :create_confirm_email_key

  validates :avatar, content_type: /\Aimage\/.*\z/ , size: { less_than: 5.megabytes }

  include RSAUtil
  include JWTUtil

  def hike_events
    HikeEvent.where(user_id: self.id)
  end

  def authenticate (password)
    return BCrypt::Password.new(self.password) == password
  end

  def remove_token
    self.token.destroy
  end

  def generate_token (overwrite = false)
    if !self.token.nil? && !self.token.frozen? && overwrite
      self.token.token = JWTUtil::encode(self)
      self.token.save
    else
      self.token = Token.new(
        token: JWTUtil::encode(self),
        user_id: self.id
      )
      self.token.save
    end

    return self.token
  end

  def create_confirm_email_key
    new_key = Base64.urlsafe_encode64(SecureRandom.hex(30))

    unless self.confirm_email_key.nil?
      self.confirm_email_key.destroy
    end
    self.confirm_email_key = ConfirmEmailKey.create(key: new_key, user_id: self.id, expires_in_s: 2.days.to_i)
    self.confirm_email_key.save

    NotificationsMailer.confirm_email(self).deliver_later

    self.confirm_email_key
  end

  def avatar_url
    if self.avatar.attached?
      return Cloudinary::Utils.cloudinary_url(self.avatar.key)
    else
      return Cloudinary::Utils.cloudinary_url('default_avatar')
    end
  end
end
