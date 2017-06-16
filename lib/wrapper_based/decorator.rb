require 'delegate'

module WrapperBased
  class Decorator < Delegator
    alias_method :initialize, def __setobj__(obj)
                                @delegate_sd_obj = obj # change delegation object
                              end

    alias_method :~@,         def __getobj__
                                @delegate_sd_obj # return object we are delegating to
                              end
  end
end
