require "test_helper"

class DCITest < Minitest::Test
  def test_new
    assert_kind_of Module, DCI
  end

  def test_wrong_types
    assert_raises(TypeError) { DCI::Roles(wrong: '') }
    assert_raises(TypeError) { DCI::Roles(wrong: 100) }
    assert_raises(TypeError) { DCI::Roles(wrong: 1.5) }
    assert_raises(TypeError) { DCI::Roles(wrong: nil) }
    assert_raises(TypeError) { DCI::Roles(wrong: true) }
  end
end
