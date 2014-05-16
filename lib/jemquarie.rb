Dir.glob(File.join(File.expand_path(File.dirname(__FILE__)), "jemquarie/*.rb")).each {|f| require f}

module Jemquarie

  class << self
    def api_key(api_key)
      Jemquarie.api_user(api_key)
    end
  end

  class Jemquarie
    BASE_URI  = "https://www.macquarie.com.au/ESI/ESIWebService/Extract"
    @api_key = nil

    class << self
      def api_key(api_key = nil)
        return @api_key unless @api_key.nil?
        @api_key = api_key
      end
    end
  end

end
