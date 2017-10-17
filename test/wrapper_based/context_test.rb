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
  end
end
