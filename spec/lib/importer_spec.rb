require 'spec_helper'

describe Jemquarie::Importer do

  before(:each) do
    Jemquarie::Jemquarie.api_credentials("testkey", "testapp")
  end

  describe "success" do
    let(:importer) do
      Jemquarie::Importer.new('valid_code', 'valid_password')
    end
    before(:each) do
      stub_request(:post, Jemquarie::Jemquarie::BASE_URI)
        .to_return(
          body: File.read('spec/files/transactions/transactions.xml'),
          headers: { content_type: 'text/xml' }
        )
      @result = importer.cash_transactions(Date.parse("01/01/2000"), Date.today, '12345')
    end
    it "should work" do
      expect(@result).to be_kind_of Array
      expect(@result.size).to eq(186)

      first_item = @result.first
      expect(first_item[:foreign_identifier]).to eq("0132058314")
      expect(first_item[:account_number]).to eq("121741987")
      expect(first_item[:date_time]).to eq(Time.parse("2008-12-19 00:00:00 UTC"))
      expect(first_item[:amount]).to eq("-2.4100")
      expect(first_item[:type_name]).to eq("B-PAY WITHDRAWAL")
      expect(first_item[:description]).to eq("BPAY TO MACQUARIE CMT")
      expect(first_item[:reverse]).to eq(false)
      expect(first_item[:meta_data][:updated_at]).to eq(Time.parse("2008-12-19 04:14:26.683 UTC"))

      last_item = @result.last
      expect(last_item[:foreign_identifier]).to eq("0342606112")
      expect(last_item[:account_number]).to eq("121741987")
      expect(last_item[:date_time]).to eq(Time.parse("2014-04-30 00:00:00 UTC"))
      expect(last_item[:amount]).to eq("0.0600")
      expect(last_item[:type_name]).to eq("INTEREST PAID")
      expect(last_item[:description]).to eq("CASH MANAGEMENT SERVICE INTEREST PAID")
      expect(first_item[:reverse]).to eq(false)
      expect(last_item[:meta_data][:updated_at]).to eq(Time.parse("2014-05-01 01:36:42.763 UTC"))


      reverse_item = @result.detect{ |row| row[:reverse] == true }
      expect(reverse_item[:foreign_identifier]).to eq(first_item[:foreign_identifier])
      expect(reverse_item[:account_number]).to eq("121741987")
      expect(reverse_item[:date_time]).to eq(Time.parse("2008-12-23 00:00:00 UTC"))
      expect(reverse_item[:amount]).to eq(first_item[:amount])
      expect(reverse_item[:type_name]).to eq(first_item[:type_name])
      expect(reverse_item[:description]).to eq(first_item[:description])
      expect(reverse_item[:reverse]).to eq(true)
      expect(reverse_item[:meta_data][:updated_at]).to eq(Time.parse("2008-12-23 04:14:26.683 UTC"))
    end

  end

  describe "single transaction success" do
    let(:importer) do
      Jemquarie::Importer.new('valid_code', 'valid_password')
    end
    before(:each) do
      stub_request(:post, Jemquarie::Jemquarie::BASE_URI)
        .to_return(
          body: File.read('spec/files/transactions/single_transaction.xml'),
          headers: { content_type: 'text/xml' }
        )
      @result = importer.cash_transactions(Date.parse("01/01/2000"), Date.today, '12345')
    end
    it "should work" do
      expect(@result).to be_kind_of Array
      expect(@result.size).to eq(1)
    end
  end

  describe "no data" do
    let(:importer) do
      Jemquarie::Importer.new('valid_code', 'valid_password')
    end
    before(:each) do
      stub_request(:post, Jemquarie::Jemquarie::BASE_URI)
        .to_return(
          body: File.read('spec/files/transactions/no_data.xml'),
          headers: { content_type: 'text/xml' }
        )
      @result = importer.cash_transactions(Date.parse("01/01/2000"), Date.today, '12345')
    end
    it "should return an empty array" do
      expect(@result).to be_kind_of Array
      expect(@result).to eq([])
    end
  end

  describe "non auth" do
    let(:importer) do
      Jemquarie::Importer.new('invalid_code', 'or_invalid_password')
    end
    before(:each) do
      stub_request(:post, Jemquarie::Jemquarie::BASE_URI)
        .to_return(
          body: File.read('spec/files/transactions/non_authenticated.xml'),
          headers: { content_type: 'text/xml' }
        )
      @result = importer.cash_transactions(Date.parse("01/01/2000"), Date.today, '12345')
    end
    it "should return wrong authentication" do
      expect(@result).to be_kind_of Hash
      expect(@result[:error]).to eq("An error has occured, please try again later")
    end
  end

  describe "wrong auth" do
    let(:importer) do
      Jemquarie::Importer.new('invalid_code', 'or_invalid_password')
    end
    before(:each) do
      stub_request(:post, Jemquarie::Jemquarie::BASE_URI)
        .to_return(
          body: File.read('spec/files/transactions/wrong_authentication.xml'),
          headers: { content_type: 'text/xml' }
        )
      @result = importer.cash_transactions(Date.parse("01/01/2000"), Date.today, '12345')
    end
    it "should return wrong authentication" do
      expect(@result).to be_kind_of Hash
      expect(@result[:error]).to eq("Invalid Authentication Code or Authentication Password")
    end
  end

  describe "non existing account number" do
    let(:importer) do
      Jemquarie::Importer.new('valid_code', 'valid_password')
    end
    before(:each) do
      stub_request(:post, Jemquarie::Jemquarie::BASE_URI)
        .to_return(
          body: File.read('spec/files/transactions/wrong_account_number.xml'),
          headers: { content_type: 'text/xml' }
        )
      @result = importer.cash_transactions(Date.parse("01/01/2000"), Date.today, 'invalid')
    end
    it "should return wrong account number" do
      expect(@result).to be_kind_of Hash
      expect(@result[:error]).to eq("Invalid Account Number")
    end
  end

  describe "with no date parameters" do
    let(:importer) do
      Jemquarie::Importer.new('valid_code', 'valid_password')
    end
    before(:each) do
      stub_request(:post, Jemquarie::Jemquarie::BASE_URI)
        .to_return(
          body: File.read('spec/files/transactions/transactions.xml'),
          headers: { content_type: 'text/xml' }
        )
    end
    it "should accept parameters with account number but no date parameters without error" do
      @result = importer.cash_transactions(nil, nil, '12345')
      expect(@result).to be_kind_of Array
      expect(@result).not_to be_empty
    end
  end

end
