require 'openssl'
require 'base64'

module AES
  
  def self.included(base)
      base.extend self
    end

    def cipherr
      OpenSSL::Cipher::Cipher.new('des-ecb')  # ('aes-256-cbc') aes-128-ecb
    end

    def cipher_keyr
      'ce3fcr7A'
    end

    def pkcs5_pad(text,blocksize)
        pad = blocksize - (text.size % blocksize)
        return text+(pad*8).to_s
    end

    def decryptr(value)
      c = cipherr.decrypt
      c.key = cipher_keyr
      c.update(Base64.decode64(value.to_s)) + c.final
    end

    def encryptr(value)
      c = cipherr.encrypt
      c.key = cipher_keyr
      Base64.encode64(c.update(value.to_s) + c.final)
    end


end
