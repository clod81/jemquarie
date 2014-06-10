require 'spec_helper'

describe Jemquarie::Jemquarie do

  describe "set api_key" do
    before :each do
      Jemquarie::Jemquarie.api_credentials('TEST', 'APP')
    end
    it "should work" do
      expect(Jemquarie::Jemquarie.api_key).to eq('TEST')
      expect(Jemquarie::Jemquarie.app_key).to eq('APP')
      expect(Jemquarie::Jemquarie.logging_enabled?).to eq(nil)
    end
  end

  describe "set api_key with logging option on" do
    before :each do
      Jemquarie::Jemquarie.api_credentials('TEST', 'APP', true)
    end
    it "should work" do
      expect(Jemquarie::Jemquarie.logging_enabled?).to eq(true)
    end
  end

end
