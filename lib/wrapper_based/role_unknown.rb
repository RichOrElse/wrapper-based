module WrapperBased
  class RoleUnknown < NoMethodError
    def self.or(error)
      return error unless error.message =~ /^undefined method `with_(\w..)/
      new error.message.sub('undefined method', 'unknown role').sub('with_','').sub('!','')
    end
  end
end
