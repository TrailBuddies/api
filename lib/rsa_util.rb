module RSAUtil
  module Keys
    def self::priv
      return ENV['RSA_PRIVATE_KEY'] || File.read('config/rsa/private.pem')
      # if ENV['RSA_PRIVATE_KEY'].nil?
      #   return ENV['RSA_PRIVATE_KEY']
      # else 
      #   return File.read('config/rsa/public.pem')
      # end
    end

    def self::pub
      return ENV['RSA_PUBLIC_KEY'] || File.read('config/rsa/public.pem')
      # if ENV['RSA_PUBLIC_KEY'].nil?
      #   return ENV['RSA_PUBLIC_KEY']
      # else
      #   return File.read('config/rsa/public.pem')
      # end
    end
  end
end
