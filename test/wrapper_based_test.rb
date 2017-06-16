require "test_helper"

class WrapperBasedTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::WrapperBased::VERSION
  end

  def test_new_dci
    assert_kind_of Module, WrapperBased::DCI.new
  end
end
