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
      response = @client.call(:generate_xml_extract, message: message)
    end

private

    def create_message(date_from, date_to)
      message = {
        :string  => Jemquarie.api_key,
        :string0 => 'Sharesight Pty Ltd', # TODO - fix this
        :string1 => @username,
        :string2 => @password,
        :string3 => 'your.clients Transactions',
        :string4 => 'V1.3',
        :string5 => [
          {
            :item0 => nil, # TODO - let the user specify which account
            :item1 => date_from.strftime("%Y-%m-%d"),
            :item2 => date_to.strftime("%Y-%m-%d"),
            :item3 => 'Y'
          }
        ]
      }
    end

  end

end
