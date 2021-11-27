class User < ApplicationRecord
  has_one :token
  after_create :generate_token

  def authenticate (password)
    return BCrypt::Password.new(self.password) == password
  end

  def generate_token (overwrite = false)
    if !self.token.nil? && overwrite
      puts 'exists and overwrite'
      t = self.token.token

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
      puts t == self.token.token
    elsif self.token.nil?
      puts 'doesnt exist'
      self.token = Token.new(
        token: JWT.encode(
            { user_id: self.id },
            OpenSSL::PKey::RSA.new(File.read('config/rsa/private.pem'), ENV['PASSPHRASE']),
            'RS256'
          ),
          user_id: self.id
      )
      self.token.save
    end

    return self.token
  end
end
