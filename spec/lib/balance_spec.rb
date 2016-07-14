require 'spec_helper'

describe Jemquarie::Balance do

  before(:each) do
    Jemquarie::Jemquarie.api_credentials("testkey", "testapp")
  end

  describe "success" do
    let(:importer) do
      Jemquarie::Balance.new('valid_code', 'valid_password')
    end
    describe "xml with balances" do
      before(:each) do
        FakeWeb.register_uri(:post, Jemquarie::Jemquarie::BASE_URI,
          body: File.read('spec/files/balance/balances.xml'),
          content_type: 'text/xml'
        )
        @result = importer.balance
      end
      it "should work" do
        expect(@result.size).to eq(106)
        first_result = @result.first
        expect(first_result[:account_number]).to eq("118498062")
        expect(first_result[:ledger_balance]).to eq("0.0000")
        expect(first_result[:available_balance]).to eq("0.0000")
        expect(first_result[:as_at_date]).to eq(Time.parse("2014-05-27 09:49:52.15 UTC"))
      end
    end
    describe "error e0009" do
      before(:each) do
        FakeWeb.register_uri(:post, Jemquarie::Jemquarie::BASE_URI,
          body: File.read('spec/files/balance/error_e0009.xml'),
          content_type: 'text/xml'
        )
        @result = importer.balance
      end
      it "should work" do
        expect(@result).to eq({:error => "Unable to process this request at this time"})
      end
    end
  end

end
