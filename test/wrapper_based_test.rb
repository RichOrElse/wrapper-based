require "test_helper"

class WrapperBasedTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::WrapperBased::VERSION
  end

  NEW_VALUE = 'NEW-VALUE'
  OLD_VALUE = 'OLD-VALUE'

  class CustomContext
    include DCI::Roles(:value, extending: Comparable, transforming: :downcase)
    public :value, :extending, :transforming
    alias_method :initialize, :with!
  end

  def setup
    @original_context = CustomContext.new(value: OLD_VALUE, extending: OLD_VALUE, transforming: OLD_VALUE)
  end

  def test_components
    assert @original_context.send :_components
  end

  def test_with!
    assert_same @original_context, @original_context.with!(value: NEW_VALUE, extending: NEW_VALUE, transforming: NEW_VALUE)
    assert_value_role @original_context
    assert_extending_role @original_context
  end

  def assert_value_role context
    assert_same NEW_VALUE, context.value
    assert_same NEW_VALUE, context.instance_variable_get(:@value)
  end

  def assert_extending_role context
    refute_same NEW_VALUE, context.extending
    assert_kind_of Delegator, context.extending
    assert_same NEW_VALUE, context.extending.__getobj__
    assert_same NEW_VALUE, context.instance_variable_get(:@extending)
  end

  def assert_transforming_role context
    assert_equal 'new-value', context.tranforming
  end
end
