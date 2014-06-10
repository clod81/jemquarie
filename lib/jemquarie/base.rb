require 'openssl'
require 'base64'

module Jemquarie

  class Base

    include Parser::Generic

    def initialize(username, password)
      @username = username
      @password = password
      @client = ::Savon.client do
        endpoint         Jemquarie::BASE_URI
        wsdl             File.expand_path("../extract.wsdl", __FILE__)
        pretty_print_xml Jemquarie.logging_enabled?
      end
    end

protected

    def hash_key(key)
      Base64.strict_encode64(OpenSSL::Digest::SHA1.digest(key))
    end

  end

end
