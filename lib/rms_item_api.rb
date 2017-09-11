require "rms_item_api/version"
require 'rms_item_api/helper.rb'
require 'rms_item_api/cabinet.rb'
require 'rms_item_api/category.rb'
require 'rms_item_api/coupon.rb'
require 'rms_item_api/item.rb'
require 'rms_item_api/navigation.rb'
require 'rms_item_api/product.rb'
require 'rms_item_api/shop_management.rb'

require 'rexml/document'
require 'yaml'
require 'faraday'
require 'active_support'
require 'active_support/core_ext'
require 'active_model'

module RmsItemApi
  class Client
    include RmsItemApi::Helper
    include RmsItemApi::Cabinet
    include RmsItemApi::Category
    include RmsItemApi::Coupon
    include RmsItemApi::Item
    include RmsItemApi::Navigation
    include RmsItemApi::Product
    include RmsItemApi::ShopManagement

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
