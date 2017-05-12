require "rms_item_api/version"
require 'rms_item_api/helper.rb'
require 'rms_item_api/item.rb'

require 'rexml/document'
require 'xmlsimple'
require 'yaml'
require 'faraday'
require 'active_support'
require 'active_support/core_ext'
require 'active_model'
require 'oga'
require 'hashie'

module RmsItemApi
  class Client
    include RmsItemApi::Helper
    include RmsItemApi::Item

    def initialize(serviceSecret:, licenseKey:)
      @serviceSecret = serviceSecret
      @licenseKey = licenseKey
      @quiet_option = nil
    end

    def quiet!
      @quiet_option = true
      self
    end

  end
end


module RmsItemApi
  class RmsItemApi < Client
    # RmsItemApi::RmsItemApi is deprecated.
  end
end
