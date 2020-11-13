$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'rms_api'

require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use!

require 'webmock/minitest'
require 'vcr'
require 'dotenv/load'

VCR.configure do |c|
  c.cassette_library_dir = 'test/cassettes'
  c.hook_into :webmock
  # 必要に応じてfilterを作成する
  # c.filter_sensitive_data('<YOUR_SELLER_ID>') { ENV['YOUR_SELLER_ID'] }
  # c.filter_sensitive_data('<YOUR_APPLICATION_ID>') { ENV['YOUR_APPLICATION_ID'] }
  # c.filter_sensitive_data('<YOUR_APPLICATION_SECRET>') { ENV['YOUR_APPLICATION_SECRET'] }
  # c.filter_sensitive_data('<YOUR_REFRESH_TOKEN>') { ENV['YOUR_REFRESH_TOKEN'] }
  # c.filter_sensitive_data('<BASIC_AUTH>') { ENV['BASIC_AUTH'] }
  c.before_record do |i|
    i.request.headers.delete('Authorization')
  end
end

module TestHelper
  module Client
    def client
      RmsApi::Client.new(
        serviceSecret: ENV['YOUR_SERVICESECRET'],
        licenseKey: ENV['YOUR_LICENSEKEY']
      )
    end
  end
end
