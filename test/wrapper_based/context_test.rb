require "test_helper"

module WrapperBased
  class ContextTest < Minitest::Test
    IncompleteContext = DCI::Context(:role) { public :role }

    def test_missing_call_method
      @context = IncompleteContext.new(role: 'exists')
      assert_not_implemented "Context must implement a call method." do
        @context.call
      end
    end

    def test_missing_role_value
      @context = IncompleteContext.new
      assert_missing_role :role do
        @context.role
      end
    end
  end
end
