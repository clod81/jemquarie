require 'spec_helper'

describe Jemquarie::Jemquarie do

  describe "set api_key" do
    before(:each) { Jemquarie::Jemquarie.api_key('TEST') }
    it "should work" do
      Jemquarie::Jemquarie.api_key.should eq 'TEST'
    end

  end

end
