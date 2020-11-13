require 'rms_api/version'
require 'rms_api/configuration.rb'
require 'rms_api/helper.rb'
require 'rms_api/item.rb'

require 'rexml/document'
require 'yaml'
require 'faraday'
require 'active_support'
require 'active_support/core_ext'
require 'active_model'

module RmsApi
  class << self
    def configure(&block)
      yield configuration
    end

    def configuration
      @configuration ||= Configuration.new
    end
  end
end
