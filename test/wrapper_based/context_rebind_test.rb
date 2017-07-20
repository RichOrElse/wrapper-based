require "test_helper"

module WrapperBased
  class ContextRebindTest < Minitest::Test
    Context = DCI::Context(:supporting, leading: Module.new)

    def setup
      @initial_data = Object.new
      @new_data = Object.new
      @context = Context.new supporting: @initial_data, leading: @initial_data
    end

    def test_context_rebind_suppporting_role
      rebinded = @context.rebind(supporting: @new_data)
      assert_same @context, rebinded
      assert_same @new_data, rebinded.supporting
    end

    def test_context_rebind_leading_role
      rebinded = @context.rebind(leading: @new_data)
      assert_same @context, rebinded
      assert_kind_of Delegator, rebinded.leading
      assert_same @new_data, rebinded.instance_variable_get(:@leading)
      assert_same @new_data, rebinded.leading.__getobj__
    end
  end
end
