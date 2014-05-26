module Jemquarie
  module Parser
    module Balance

       def parse_balance_response(response)
        result = generic_request_response(response)
        return result if result[:error]
        balances = []
        return balances unless result["XMLExtract"] && result["XMLExtract"]["yourclientsBalances"] && result["XMLExtract"]["yourclientsBalances"]["yourclientsBalance"]
        xml_balances = if result["XMLExtract"]["yourclientsBalances"]["yourclientsBalance"].is_a?(Hash)
          [result["XMLExtract"]["yourclientsBalances"]["yourclientsBalance"]]
        else
          result["XMLExtract"]["yourclientsBalances"]["yourclientsBalance"]
        end
        xml_balances.each do |balance|
          balances << parse_single_balance(balance)
        end
        balances
      end

private

      def parse_single_balance(balance)
        {
          :account_number    => balance["AccountNumber"],
          :ledger_balance    => balance["LedgerBalance"],
          :available_balance => balance["AvailableBalance"],
          :as_at_date        => Time.parse(balance["AsAtDate"] + " UTC")
        }
      end

    end
  end
end
