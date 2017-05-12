require "rms_item_api/version"
require 'rms_item_api/helper.rb'
require 'rms_item_api/item.rb'

require 'rexml/document'
require 'yaml'
require 'faraday'
require 'active_support'
require 'active_support/core_ext'
require 'active_model'

module RmsItemApi
  class Client
    include RmsItemApi::Helper
    include RmsItemApi::Item

    def initialize(serviceSecret:, licenseKey:)
      @serviceSecret = serviceSecret
      @licenseKey = licenseKey
    end

  end
end

module RmsItemApi
  class RmsItemApi < Client
    # RmsItemApi::RmsItemApi is deprecated.
  end
end
