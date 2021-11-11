class User < ApplicationRecord
  has_one :token
  def authenticate (password)
    return BCrypt::Password.new(self.password) == password
  end
end
