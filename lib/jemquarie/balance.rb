module Jemquarie

  class Balance < Base

    include Parser::Balance

    def balance(account_number = '')
      response = @client.call(:generate_xml_extract, :message => create_message(account_number))
      return parse_balance_response(response) if response.success?
      {:error => "An error has occured, please try again later"}
    end

private

    def create_message(account_number)
      {
        :string  => hash_key(Jemquarie.api_key), # base64 encoded of the sha1 hashed api key
        :string0 => Jemquarie.app_key,
        :string1 => hash_key(@username),
        :string2 => hash_key(@password),
        :string3 => 'your.clients Balances',
        :string4 => 'V1.5',
        :strings => [
          {
            :item0 => account_number, # Account Number
            :item1 => 'Y',
            :item2 => '',
            :item3 => ''
          }
        ]
      }
    end

  end

end
