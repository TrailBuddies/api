require 'securerandom'
require 'base64'

class User < ApplicationRecord
  has_one :token, dependent: :destroy
  has_one :confirm_email_key, dependent: :destroy
  has_many :hike_events, dependent: :destroy
  after_create :generate_token, :create_confirm_email_key

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
    if !self.token.nil? && overwrite
      self.token.token = JWT.encode(
        {
          iss: 'probably digitalocean or some shit',
          iat: Time.now.to_i,
          sub: self.id
        },
        OpenSSL::PKey::RSA.new(File.read('config/rsa/private.pem'), ENV['PASSPHRASE']),
        'RS256'
      )
      self.token.save
    elsif self.token.nil?
      self.token = Token.new(
        token: JWT.encode(
          {
            iss: 'probably digitalocean or some shit',
            iat: Time.now.to_i,
            sub: self.id + Time.now.to_s
          },
          OpenSSL::PKey::RSA.new(File.read('config/rsa/private.pem'), ENV['PASSPHRASE']),
          'RS256'
        ),
        user_id: self.id
      )
      self.token.save
    end

    return self.token
  end

  def create_confirm_email_key
    new_key = Base64.urlsafe_encode64(SecureRandom.hex(30))

    if self.confirm_email_key.nil?
      self.confirm_email_key = ConfirmEmailKey.create(key: new_key, user_id: self.id, expires_in_s: 2.days.to_i)
    else
      self.confirm_email_key.key = new_key
    end

    self.confirm_email_key.save

    ConfirmJob.perform_later(self.id)
  end
end
