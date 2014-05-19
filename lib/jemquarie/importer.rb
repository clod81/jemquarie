require 'openssl'
require 'base64'

module Jemquarie

  class Importer

    include Jemquarie::Parser::CashTransactions

    def initialize(username, password)
      @username = username
      @password = password
      @client = ::Savon.client do
        endpoint         Jemquarie::BASE_URI
        wsdl             File.expand_path("../extract.wsdl", __FILE__)
        pretty_print_xml true
      end
    end

    def cash_transactions(date_from = (Date.today - 1.day), date_to = Date.today, account_number = '')
      if account_number.blank? && ((date_to - date_from) > 2.days) # if no account specified, ESI api doesn't allow to ask more than 2 days of transactions
        return {:error => "Cannot request more than 2 days of transactions if not account is specified"}
      end
      response = @client.call(:generate_xml_extract, :message => create_message(date_from, date_to, account_number))
      parse_cash_transactions_response(response)
    end

private

    def create_message(date_from, date_to, account_number)
      {
        :string  => hash_key(Jemquarie.api_key), # base64 encoded of the sha1 hashed api key
        :string0 => Jemquarie.app_key,
        :string1 => hash_key(@username),
        :string2 => hash_key(@password),
        :string3 => 'your.clients Transactions',
        :string4 => 'V1.4',
        :strings => [
          {
            :item0 => account_number,                          # Account Number
            :item1 => date_from.strftime("%Y-%m-%dT%H:%M:%S"), # START DATE
            :item2 => date_to.strftime("%Y-%m-%dT%H:%M:%S"),   # TO DATE
            :item3 => 'Y'                                      # Include closed accounts flag
          }
        ]
      }
    end

    def hash_key(key)
      Base64.strict_encode64(OpenSSL::Digest::SHA1.digest(key))
    end

  end

end
