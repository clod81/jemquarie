require 'spec_helper'

describe Jemquarie::Jemquarie do

  describe "set api_key" do
    before do
      Jemquarie::Jemquarie.api_credentials('TEST', 'APP')
    end
    it "should work" do
      expect(Jemquarie::Jemquarie.api_key).to eq('TEST')
      expect(Jemquarie::Jemquarie.app_key).to eq('APP')
    end
  end

end
