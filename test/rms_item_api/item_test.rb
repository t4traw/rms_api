require 'rms_item_api'
require 'test_helper'

class RmsItemApiTest < Minitest::Test
  include TestHelper::Client

  def test_get
    VCR.use_cassette('get/test_get') do
      assert_equal 'test_item', client.get('test1234').item_name
    end
  end

end
