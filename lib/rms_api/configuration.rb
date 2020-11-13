module RmsApi
  class Configuration
    attr_accessor :service_secret, :license_key

    def initialize
      @service_secret = ENV['RMS_SERVICE_SECRET']
      @license_key = ENV['RMS_LICENSE_KEY']
    end
  end
end
