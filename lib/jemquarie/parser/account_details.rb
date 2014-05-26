module Jemquarie
  module Parser
    module AccountDetails

       def parse_account_details(response)
        result = generic_request_response(response)
        return result if result[:error]
        details = []
        return details unless result["XMLExtract"]["yourclientsAccountDetails"] && result["XMLExtract"]["yourclientsAccountDetails"]["yourclientsAccountDetail"]
        xml_details = if result["XMLExtract"]["yourclientsAccountDetails"]["yourclientsAccountDetail"].is_a?(Hash)
          [result["XMLExtract"]["yourclientsAccountDetails"]["yourclientsAccountDetail"]]
        else
          result["XMLExtract"]["yourclientsAccountDetails"]["yourclientsAccountDetail"]
        end
        xml_details.each do |detail|
          details << parse_single_detail(detail)
        end
        details
      end

private

      def parse_single_detail(detail)
        {
          :account_number       => detail["AccountNumber"],
          :account_name         => detail["AccountName"],
          :account_short_name   => detail["AccountShortName"],
          :product              => detail["Product"],
          :product_name         => detail["ProductName"],
          :address_line_1       => detail["AddressLine1"],
          :address_line_4       => detail["AddressLine4"],
          :address_line_5       => detail["AddressLine5"],
          :address_line_6       => detail["AddressLine6"],
          :dealer_code          => detail["DealerCode"],
          :adviser_code         => detail["AdviserCode"],
          :account_status       => detail["AccountStatus"],
          :date_modified        => Time.parse(detail["DateModified"] + " UTC"),
          :bsb                  => detail["Bsb"],
          :primary_broker_name  => detail["PrimaryBrokerName"],
          :primary_adviser_name => detail["PrimaryAdviserName"]
        }
      end

    end
  end
end
