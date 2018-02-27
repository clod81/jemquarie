require 'spec_helper'

describe Jemquarie::Expiry do

  before(:each) do
    Jemquarie::Jemquarie.api_credentials("testkey", "testapp")
  end

  describe "success" do
    let(:importer) do
      Jemquarie::Expiry.new('valid_code', 'valid_password')
    end
    before(:each) do
      stub_request(:post, Jemquarie::Jemquarie::BASE_URI)
        .to_return(
          body: File.read('spec/files/expiry/expiry.xml'),
          headers: { content_type: 'text/xml' }
        )
      @result = importer.credentials_expiry
    end
    it "should work" do
      expect(@result).to eq(Time.parse("2015-01-14 10:22:12.03 UTC"))
    end
  end

end
