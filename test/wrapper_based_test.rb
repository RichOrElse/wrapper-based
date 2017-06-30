require "test_helper"

class WrapperBasedTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::WrapperBased::VERSION
  end
end
