require "wrapper_based/version"
require "wrapper_based/cast"
require "wrapper_based/context"
require "wrapper_based/dci"
require "wrapper_based/decorator"

module WrapperBased
  FORWARDING = -> type, *behaviors do
                Class.new(Decorator) do
                  using Module.new { refine(type) { prepend(*behaviors.reverse) } }

                  def method_missing(meth, *args, &block)
                    __getobj__.send(meth, *args, &block)
                  end
                end
              end
end
