module Jemquarie

  class Service < Base

    include Parser::Service

    def date
      response = @client.call :generate_xml_extract, :message => create_message
      return parse_service_date(response) if response.success?
      {:error => "An error has occured, please try again later"}
    end

private

    def create_message
      {
        :string  => hash_key(Jemquarie.api_key), # base64 encoded of the sha1 hashed api key
        :string0 => Jemquarie.app_key,
        :string1 => hash_key(@username),
        :string2 => hash_key(@password),
        :string3 => 'your.clients Service Date',
        :string4 => 'V1.1'
      }
    end

  end

end
