require "type_wrapper"

module DCI
  Module = Class.new(TypeWrapper::Module)

  @@casting_pool = WrapperBased::Casting::Pool.new(TypeWrapper)

  class << self
    def Context(*roles, &block)
      fail_on_wrong_talent_type { return @@casting_pool.context_for(*roles, &block) }
    end

    def Roles(*roles)
      fail_on_wrong_talent_type { return @@casting_pool.casting_for(*roles) }
    end

    private

    def fail_on_wrong_talent_type(&blk)
      key, wrong, expected = catch(:wrong_talent_type, &blk)
      message = "'#{key}: #{wrong}' has wrong key value type #{wrong.class} (#{expected})"
      raise TypeError, message, caller
    end
  end
end
