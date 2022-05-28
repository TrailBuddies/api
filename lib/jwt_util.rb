module JWTUtil
  include RSAUtil

  module Auth
    def self::gen_access_token(user)
      JWTUtil::encode(user.id + '.' + Time.now.to_s)
    end

    def self::gen_refresh_token(user)
      JWTUtil::encode(user.id + '.' + Time.now.to_s)
    end
  end


  def self::encode(payload)
    JWT.encode(
      {
        iss: 'probably digitalocean or some shit',
        iat: Time.now.to_i,
        sub: payload
      },
      OpenSSL::PKey::RSA.new(RSAUtil::Keys::priv, ENV['PASSPHRASE']),
      'RS256'
    )
  end

  def self::decode(token)
    begin
      JWT.decode(
        token,
        OpenSSL::PKey::RSA.new(RSAUtil::Keys::pub, ENV['PASSPHRASE']),
        true,
        { algorithm: 'RS256' }
      )
    rescue JWT::DecodeError
      return nil
    end
  end
end