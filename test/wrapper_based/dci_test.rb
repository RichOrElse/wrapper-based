require "test_helper"

module WrapperBased
  class DCITest < Minitest::Test
    def setup
       @dci = WrapperBased::DCI.new
    end

    def test_new
      assert_kind_of Module, @dci
    end

    def test_context_to_proc
      ctx = @dci::Context(:input) { def call() :output end }

      assert ctx[input: nil].to_proc
      assert_equal :output, ctx[input: nil].to_proc.call
    end

    def test_context_square_brackets
      ctx = @dci::Context(:a) { def call(b:) a + b end }

      assert_equal 3, ctx[a: 1][b: 2]
    end
  end
end
