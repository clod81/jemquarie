Dir.glob(File.join(File.expand_path(File.dirname(__FILE__)), "jemquarie/parser/*.rb")).each {|f| require f}
Dir.glob(File.join(File.expand_path(File.dirname(__FILE__)), "jemquarie/*.rb")).each {|f| require f}

module Jemquarie

  class << self
    def api_key(api_key, application = 'Jemquarie Gem')
      Jemquarie.api_user(api_key)
      Jemquarie.application_key(application)
    end
  end

  class Jemquarie
    BASE_URI = "https://www.macquarie.com.au/ESI/ESIWebService/Extract"
    @api_key = nil
    @app_key = nil

    class << self
      def api_key(api_key = nil)
        return @api_key unless @api_key.nil?
        @api_key = api_key
      end
      def application_key(app_key = nil)
        return @app_key unless @app_key.nil?
        @app_key = app_key
      end
    end
  end

end
