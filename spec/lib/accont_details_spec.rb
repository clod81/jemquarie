require 'spec_helper'

describe Jemquarie::AccountDetails do

  before(:each) do
    Jemquarie::Jemquarie.api_credentials("testkey", "testapp")
  end

  describe "success" do
    let(:importer) do
      Jemquarie::AccountDetails.new('valid_code', 'valid_password')
    end
    before(:each) do
      FakeWeb.register_uri(:post, Jemquarie::Jemquarie::BASE_URI,
        body: File.read('spec/files/account_details/details.xml'),
        content_type: 'text/xml'
      )
      @result = importer.details(Date.parse("01/01/2000"), Date.today)
    end
    it "should work" do
      expect(@result).to have(182).items
      first_res = @result.first
      expect(first_res[:account_number]).to eq("118115765")
      expect(first_res[:account_name]).to eq("JAMES ANDREW LOCKETT")
      expect(first_res[:account_short_name]).to eq("LOCKETT J A")
      expect(first_res[:product]).to eq("CMH")
      expect(first_res[:product_name]).to eq("CASH MANAGEMENT ACCOUNT")
      expect(first_res[:address_line_1]).to eq("PO BOX 3174")
      expect(first_res[:address_line_4]).to eq("MARRICKVILLE METRO")
      expect(first_res[:address_line_5]).to eq("NSW")
      expect(first_res[:address_line_6]).to eq("2204")
      expect(first_res[:dealer_code]).to eq("0000")
      expect(first_res[:adviser_code]).to eq("CASH")
      expect(first_res[:account_status]).to eq("Open")
      expect(first_res[:date_modified]).to eq(Time.parse("2014-05-01 01:14:27.546 UTC"))
      expect(first_res[:bsb]).to eq("182222")
      expect(first_res[:primary_broker_name]).to eq("MACQUARIE INVESTMENT MANAGEMENT LTD")
      expect(first_res[:primary_adviser_name]).to eq("FORREST           PETER        MR")
    end
  end

end
