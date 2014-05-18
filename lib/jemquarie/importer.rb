require 'digest/sha1'
require 'base64'

module Jemquarie

  class Importer

    def initialize(username, password)
      @username = username
      @password = password
      @client = ::Savon.client do
        endpoint Jemquarie::BASE_URI
        wsdl     File.expand_path("../extract.wsdl", __FILE__)
        pretty_print_xml true
      end
    end

    def cash_transaction(date_from=Date.today, date_to=Date.today)
      response = @client.call(:generate_xml_extract, :message => create_message(date_from, date_to))
    end

private

    def create_message(date_from, date_to, account_number=nil)
      {
        :string  => hash_key(Jemquarie.api_key), # base64 encoded of the sha1 hashed api key
        :string0 => 'Sharesight Pty Ltd', # TODO - fix this
        :string1 => hash_key(@username),
        :string2 => hash_key(@password),
        :string3 => 'your.clients Transactions',
        :string4 => 'V1.3',
        :strings => [
          {
            :item0 => account_number,                 # Account Number - TODO - let the user specify which account
            :item1 => date_from.strftime("%Y-%m-%d"), # START DATE
            :item2 => date_to.strftime("%Y-%m-%d"),   # TO DATE
            :item3 => 'Y'                             # Include closed accounts flag
          }
        ]
      }
    end

    def hash_key(key)
      Base64.encode64(Digest::SHA1.hexdigest(key))
    end

  end

end
