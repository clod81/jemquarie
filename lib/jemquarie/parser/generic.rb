module Jemquarie
  module Parser
    module Generic

      def generic_request_response(response)
        body = response.body
        return {:error => "An error has occured, please try again later"} unless
          body[:generate_xml_extract_response] && body[:generate_xml_extract_response][:result] && body[:generate_xml_extract_response][:result].is_a?(String)
        result = Hash.from_xml(Nokogiri::XML.fragment(body[:generate_xml_extract_response][:result]).to_s)
        return {error: result["XMLExtract"]["RequestDetails"]["RequestErrorDetails"], code: result["XMLExtract"]["RequestDetails"]["RequestErrorNumber"]} if result["XMLExtract"]["RequestDetails"]["RequestStatus"] == "Failure"
        result
      end

    end
  end
end
