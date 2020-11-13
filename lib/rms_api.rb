require 'rms_api/version'
require 'rms_api/helper.rb'
require 'rms_api/item.rb'

require 'rexml/document'
require 'yaml'
require 'faraday'
require 'active_support'
require 'active_support/core_ext'
require 'active_model'

module RmsApi
  class Client
    include RmsApi::Helper
    include RmsApi::Item

    def initialize(serviceSecret:, licenseKey:)
      @serviceSecret = serviceSecret
      @licenseKey = licenseKey
    end
  end
end
