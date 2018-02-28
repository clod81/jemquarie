module Jemquarie
  module Parser
    module Service

      def parse_service_date(response)
        result = generic_request_response(response)
        return result if result[:error]
        Date.parse result["XMLExtract"]["ServiceDate"]
      end

    end
  end
end
