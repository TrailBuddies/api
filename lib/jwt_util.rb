module JWTUtil
  include RSAUtil

  def self::encode(user)
    JWT.encode(
      {
        iss: 'probably digitalocean or some shit',
        iat: Time.now.to_i,
        sub: user.id + '.' + Time.now.to_s + '.' + SecureRandom.hex(5)
      },
      OpenSSL::PKey::RSA.new(RSAUtil::Keys::priv, RSAUtil::Keys::passphrase),
      'RS256'
    )
  end

  def self::decode(token)
    begin
      JWT.decode(
        token,
        OpenSSL::PKey::RSA.new(RSAUtil::Keys::pub, RSAUtil::Keys::passphrase),
        true,
        { algorithm: 'RS256' }
      )
    rescue JWT::DecodeError
      return nil
    end
  end
end