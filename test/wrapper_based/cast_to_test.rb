require "test_helper"

module WrapperBased
  class CastToTest < Minitest::Test
    def test_module
      ctx = DCI::Context(role: Comparable) { def call() role end }
      assert_equal 1, ctx.(role: 1)
    end
    def test_class
      ctx = DCI::Context(role: String) { def call() role end }
      assert_equal 'hello', ctx.(role: 'hello')
    end

    def test_proc
      ctx = DCI::Context(role: -> x { x * 3 }) { def call() role end }
      assert_equal 30, ctx.(role: 10)
    end

    def test_method
      power = DCI::Context(is_over: 9999.method(:>)) { def call() is_over end }
      assert_equal true, power.(is_over: 9000)
    end

    def test_wrong_type
      assert_raises(TypeError) { DCI::Context(wrong: 0) }
    end
  end
end
