require "test_helper"

class WrapperBasedTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::WrapperBased::VERSION
  end

  def test_new_dci
    assert_kind_of Module, WrapperBased::DCI.new
  end

  def test_decorator_enscapulation
    type = Class.new do
      def accessible
        :visible
      end

      def secret
        :hidden
      end

      private :secret
    end

    behavior = Module.new do
      def accessible2
        :visible
      end

      def secret2
        :hidden
      end

      private :secret2
    end

    wrapped = WrapperBased::FORWARDING[type, behavior].new(type.new)

    assert_equal :visible, wrapped.accessible
    assert_equal :visible, wrapped.accessible2
    assert_raises(NameError) { wrapped.secret }
    assert_raises(NameError) { wrapped.secret2 }
  end
end
