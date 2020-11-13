require 'test_helper'

class RmsApiTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::RmsApi::VERSION
  end
end
