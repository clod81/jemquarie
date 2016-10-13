require 'spec_helper'

describe Jemquarie::Service do

  before(:each) do
    Jemquarie::Jemquarie.api_credentials("testkey", "testapp")
  end

  let(:importer) do
    Jemquarie::Service.new('valid_code', 'valid_password')
  end

  describe "success" do
    before(:each) do
      FakeWeb.register_uri(:post, Jemquarie::Jemquarie::BASE_URI,
        body: File.read('spec/files/service/success.xml'),
        content_type: 'text/xml'
      )
      @result = importer.date
    end
    it "should work" do
      expect(@result).to eq(Date.parse("2016-10-12"))
    end
  end

  describe "failures" do
    before(:each) do
      FakeWeb.register_uri(:post, Jemquarie::Jemquarie::BASE_URI,
        body: File.read('spec/files/service/failure.xml'),
        content_type: 'text/xml'
      )
    end
    it "should raise nothing" do
      @result = importer.date
    end
  end

end
