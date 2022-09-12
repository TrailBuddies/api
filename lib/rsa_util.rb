module RSAUtil
  module Keys
    def self::priv
      return File.read('config/rsa/private.pem')
    end

    def self::pub
      return File.read('config/rsa/public.pem')
    end
  end
end
