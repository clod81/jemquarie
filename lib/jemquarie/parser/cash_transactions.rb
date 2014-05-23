module Jemquarie
  module Parser
    module CashTransactions

      def parse_cash_transactions_response(response)
        body = response.body
        return {:error => "Invalid Authentication Code or Authentication Password"} unless
          body[:generate_xml_extract_response] && body[:generate_xml_extract_response][:result] && body[:generate_xml_extract_response][:result].is_a?(String)
        result = Hash.from_xml(Nokogiri::XML.fragment(body[:generate_xml_extract_response][:result]).to_s)
        return {error: result["XMLExtract"]["RequestDetails"]["RequestErrorDetails"]} if result["XMLExtract"]["RequestDetails"]["RequestStatus"] == "Failure"
        transactions = []
        return transactions unless result["XMLExtract"] && result["XMLExtract"]["yourclientsTransactions"] && result["XMLExtract"]["yourclientsTransactions"]["yourclientsTransaction"]
        xml_transactions = if result["XMLExtract"]["yourclientsTransactions"]["yourclientsTransaction"].is_a?(Hash)
          [result["XMLExtract"]["yourclientsTransactions"]["yourclientsTransaction"]]
        else
          result["XMLExtract"]["yourclientsTransactions"]["yourclientsTransaction"]
        end
        xml_transactions.each do |transaction|
          transactions << parse_single_transaction(transaction)
        end
        transactions
      end

private

      def parse_single_transaction(transaction)
        {
          :foreign_identifier => transaction["TransactionId"],
          :date_time          => Time.parse(transaction["TransactionDate"] + " UTC"),
          :amount             => transaction["DebitCredit"] == 'C' ? transaction["Amount"] : ('-' + transaction["Amount"]),
          :type_name          => translate_transaction_type(transaction["TransactionType"]),
          :description        => transaction["Narrative"],
          :meta_data => {
            :updated_at       => Time.parse(transaction["DateModified"] + " UTC")
          }
        }
      end

      def translate_transaction_type(type)
        list = [
          {:key => '04', :value => 'WITHDRAWAL'},
          {:key => '06', :value => 'AUTHORITY TRANSFER'},
          {:key => '07', :value => 'INTERNATIONAL DEBIT'},
          {:key => '08', :value => 'DIRECT ENTRY DEBIT'},
          {:key => '09', :value => 'CHEQUE'},
          {:key => '11', :value => 'DEBIT BATCH VALUE DOCUMENT'},
          {:key => '12', :value => 'INTERBANK DEBIT'},
          {:key => '13', :value => 'WITHDRAWAL'},
          {:key => '14', :value => 'TELEGRAPHIC TRANSFER'},
          {:key => '15', :value => 'RETURNED CHEQUE'},
          {:key => '16', :value => 'RETURNED CHEQUE CHARGE'},
          {:key => '17', :value => 'ERROR IN DEPOSIT - ADJUSTMENT'},
          {:key => '18', :value => 'INTERNATIONAL DEBIT'},
          {:key => '19', :value => 'INTEREST ADJUSTMENT'},
          {:key => '20', :value => 'CASH ACCOUNT DEBIT'},
          {:key => '21', :value => 'FIN INST DUTY'},
          {:key => '22', :value => 'FX TRANSACTION'},
          {:key => '23', :value => 'SEARCH FEE'},
          {:key => '24', :value => 'STATE DEBITS TAX'},
          {:key => '25', :value => 'WITHHOLDING TAX'},
          {:key => '26', :value => 'ATM WITHDRAWAL'},
          {:key => '27', :value => 'VISA SALE'},
          {:key => '29', :value => 'MISCELLANEOUS DEBIT FRC'},
          {:key => '30', :value => 'SPECIAL CLEARING CHARGE'},
          {:key => '39', :value => 'INTEREST CHARGED'},
          {:key => '43', :value => 'BANK FEE'},
          {:key => '44', :value => 'MISCELLANEOUS DEBIT'},
          {:key => '45', :value => 'STAMP DUTY'},
          {:key => '46', :value => 'PERIODICAL PAYMENT DEBIT'},
          {:key => '47', :value => 'REVERSAL DEBIT'},
          {:key => '49', :value => 'CHEQUE BOOK'},
          {:key => '50', :value => 'DEPOSIT'},
          {:key => '51', :value => 'GOVT SECURITY INTEREST'},
          {:key => '52', :value => 'FAMILY ALLOWANCE'},
          {:key => '53', :value => 'SALARY'},
          {:key => '54', :value => 'PENSION'},
          {:key => '55', :value => 'SERVICE ALLOTMENT'},
          {:key => '56', :value => 'DIVIDEND'},
          {:key => '57', :value => 'DEBENTURE NOTE INTEREST'},
          {:key => '58', :value => 'GENERAL CREDIT'},
          {:key => '59', :value => 'CREDIT BATCH VALUE DOCUMENT'},
          {:key => '60', :value => 'DEPOSIT AGT'},
          {:key => '61', :value => 'TELEGRAPHIC TRANSFER'},
          {:key => '62', :value => 'ERROR IN DEPOSIT - ADJUSTMENT'},
          {:key => '63', :value => 'INTEREST ADJUSTMENT'},
          {:key => '64', :value => 'BILL ROLLOVER'},
          {:key => '66', :value => 'FX TRANSACTION'},
          {:key => '67', :value => 'INTERBANK CREDIT'},
          {:key => '68', :value => 'INTERNATIONAL CREDIT'},
          {:key => '69', :value => 'AUTHORITY TRANSFER'},
          {:key => '70', :value => 'DEPOSIT'},
          {:key => '71', :value => 'INTERBANK USE NOT AVAILABLE'},
          {:key => '72', :value => 'REV FINANCIAL INSTITUTION DUTY'},
          {:key => '73', :value => 'INTEREST PAID'},
          {:key => '74', :value => 'REV FEDERAL DEBITS TAX'},
          {:key => '76', :value => 'SWEEP ACCOUNT INTEREST'},
          {:key => '77', :value => 'NEGATIVE DISTRIBUTION'},
          {:key => '78', :value => 'DISHONOURED ITEM'},
          {:key => '82', :value => 'REV WITHHOLDING TAX'},
          {:key => '86', :value => 'BANK CHEQUE-REVERSAL'},
          {:key => '87', :value => 'REVERSAL CHEQUE'},
          {:key => '88', :value => 'REVERSAL CEMTEX'},
          {:key => '89', :value => 'REV INTEREST CHARGED'},
          {:key => '90', :value => 'REVERSAL CREDIT'},
          {:key => '91', :value => 'REVERSAL OF CHARGE'},
          {:key => '92', :value => 'PERIODICAL CREDIT'},
          {:key => '93', :value => 'DEPOSIT'},
          {:key => '94', :value => 'REVERSAL RTGS REDEMP'},
          {:key => '95', :value => 'DEPOSIT'},
          {:key => '96', :value => 'MISCELLANEOUS CREDIT FRC'},
          {:key => '99', :value => 'MISCELLANEOUS CREDIT'},
          {:key => 'AF', :value => 'APPLICATION FEE'},
          {:key => 'BB', :value => 'BPAY DEPOSIT'},
          {:key => 'BC', :value => 'BANK CHEQUE'},
          {:key => 'BD', :value => 'BANK CHEQUE FEE'},
          {:key => 'BP', :value => 'B-PAY WITHDRAWAL'},
          {:key => 'BT', :value => 'DEPOSIT BANK TRANSFER'},
          {:key => 'CA', :value => 'DEPOSIT - CASH'},
          {:key => 'CC', :value => 'CHEQUE ISSUE FEE'},
          {:key => 'CD', :value => 'DEPOSIT - CHEQUE'},
          {:key => 'CQ', :value => 'FEE FOR CHQ TRANSACTIONS'},
          {:key => 'CW', :value => '## EXCESS CHQ WITHDRAWALS'},
          {:key => 'DC', :value => 'WITHDRAWAL-CHEQUE'},
          {:key => 'DD', :value => 'WITHDRAWAL-BANK TRF'},
          {:key => 'DF', :value => 'TRANSFER FROM'},
          {:key => 'DI', :value => 'RETURNED DIRECT DEBIT FEE'},
          {:key => 'DM', :value => 'ADDITIONAL STATEMENT FEE'},
          {:key => 'DN', :value => 'EXCESS CHEQUE DEPOSITS'},
          {:key => 'DS', :value => 'DISHONOUR - SAVING PLAN DEPOSIT'},
          {:key => 'DT', :value => 'TRANSFER TO'},
          {:key => 'EF', :value => 'ESTABLISHMENT FEE'},
          {:key => 'FD', :value => 'FIXED PAYMENT-BANK TFR'},
          {:key => 'FM', :value => 'MINIMUM BALANCE CHARGE'},
          {:key => 'FT', :value => 'TRANSACTION CHARGES'},
          {:key => 'IC', :value => 'CR INCOME ADJUSTMENT'},
          {:key => 'ID', :value => 'DR INCOME ADJUSTMENT'},
          {:key => 'JA', :value => 'INTERNAL APPLICATION'},
          {:key => 'JR', :value => 'INTERNAL REDEMPTION'},
          {:key => 'MC', :value => 'WITHDRAWAL - MANUAL CHEQUE'},
          {:key => 'MF', :value => 'MISCELLANEOUS FEES'},
          {:key => 'MM', :value => 'MANAGEMENT FEE'},
          {:key => 'ND', :value => 'NET INCOME BANK TRANSFER'},
          {:key => 'NF', :value => 'NET TAXES AND FEES'},
          {:key => 'NR', :value => 'NET INCOME REINVEST'},
          {:key => 'OB', :value => 'OPENING BALANCE'},
          {:key => 'OC', :value => 'OVERSEAS BANK DRAFT FEE'},
          {:key => 'OS', :value => 'EXCESS CHEQUE DEPOSITS DEBIT'},
          {:key => 'OT', :value => 'OVERSEAS TELEGRAPH TRANSFER FE'},
          {:key => 'RD', :value => 'RTGS APPLICATIONS'},
          {:key => 'RT', :value => "RES INVEST W'HOLDING TAX"},
          {:key => 'RW', :value => 'RTGS REDEMPTION'},
          {:key => 'SC', :value => 'SWITCH CREDIT TRANS'},
          {:key => 'SD', :value => 'SWITCH DEBIT TRANS'},
          {:key => 'SF', :value => 'SAVINGS PLAN FEES'},
          {:key => 'SP', :value => 'SAVINGS PLAN DEPOSIT'},
          {:key => 'ST', :value => 'STOP PAYMENT FEE'},
          {:key => 'TC', :value => 'WITHDRAWAL - CHEQUE'},
          {:key => 'TD', :value => 'WITHDRAWAL - BANK TRF'},
          {:key => 'WF', :value => 'WITHDRAWAL FEE'},
          {:key => 'XC', :value => 'SWITCH OF INVESTMENT FUNDS'},
          {:key => 'XD', :value => 'SWITCH OF INVESTMENT FUNDS'}
        ]
        item = list.detect{|t| t[:key] == type}
        return unless item
        item[:value]
      end

    end
  end
end

