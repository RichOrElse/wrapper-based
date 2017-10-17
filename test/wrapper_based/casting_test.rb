require "test_helper"

module WrapperBased
  class CastingTest < Minitest::Test
    module HashExtention
      def slice(*keys)
        keys.each_with_object(self.class.new) { |k, hash| hash[k] = self[k] if has_key?(k) }
      end
    end

    class MixedContext < DCI::Context(:params,
                                      time: Time,
                                      email: :downcase,
                                      triple: -> x { x * 3 },
                                      over_nine_thousand: 9000.method(:<))
      include DCI::Roles(params: HashExtention)
      public :params
    end

    def test_that_role_getters_and_setters_are_private
      context_private_methods = MixedContext.private_instance_methods
      [:time, :email, :triple, :over_nine_thousand].each do |role|
        assert_includes context_private_methods, role
        assert_includes context_private_methods, :"#{role}="
      end

    end

    def test_that_role_casting_methods_are_public
      casting_public_methods = MixedContext.public_instance_methods
      assert_includes casting_public_methods, :with_params!
      assert_includes casting_public_methods, :with_time!
      assert_includes casting_public_methods, :with_email!
      assert_includes casting_public_methods, :with_triple!
      assert_includes casting_public_methods, :with_over_nine_thousand!
    end

    def test_that_roles_are_transformed_by_proc
      computes = MixedContext.new triple: 10
      assert_equal 30, computes.send(:triple)
    end

    def test_that_roles_are_transformed_by_method
      power_level = MixedContext.new
      assert_equal false, power_level.with!(over_nine_thousand: 8999).send(:over_nine_thousand)
      assert_equal false, power_level.with!(over_nine_thousand: 9000).send(:over_nine_thousand)
      assert_equal true, power_level.with!(over_nine_thousand: 9001).send(:over_nine_thousand)
    end

    def test_that_roles_are_transformed_by_symbol
      sanitizes = MixedContext.new email: 'EXAMPLE@EMAIL.COM'
      assert_equal 'example@email.com', sanitizes.send(:email)
    end

    def test_that_roles_are_new_class_instance
      history = MixedContext.new(time: '1993-02-24')

      old_time = history.send :time
      new_time = history.with!(time: '1993-02-24').send :time

      assert_kind_of Time, old_time
      assert_kind_of Time, new_time
      assert_equal old_time, new_time
      refute_same old_time, new_time
    end

    def test_that_roles_are_module_extended
      controller = MixedContext.new params: { a: 1, b: 2, c: 3 }
      permitted = { a: 1, c: 3 }
      assert_equal permitted, controller.params.slice(:a, :c)
    end
  end
end
