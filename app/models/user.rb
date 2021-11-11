class User < ApplicationRecord
  def authenticate (password)
    return BCrypt::Password.new(self.password) == password
  end
end
