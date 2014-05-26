module Jemquarie
  module Parser
    module Expiry

       def parse_expiry_response(response)
        result = generic_request_response(response)
        return result if result[:error]
        result["XMLExtract"]["ExpiryDate"]
        Time.parse(result["XMLExtract"]["ExpiryDate"] + " UTC")
      end

    end
  end
end
