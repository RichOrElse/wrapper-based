require "wrapper_based/version"
require "wrapper_based/cast"
require "wrapper_based/context"
require "wrapper_based/context/builder"
require "wrapper_based/decorator"

module WrapperBased
  FORWARDING = -> type, *behaviors do
                Class.new(Decorator) do
                  using Module.new { refine(type) { prepend(*behaviors.reverse) } }

                  forwarding = behaviors.flat_map(&:public_instance_methods) - public_instance_methods

                  forwarding.uniq.each do |meth|
                    define_method(meth) do |*args, &block|
                      __getobj__.send(meth, *args, &block)
                    end
                  end
                end
              end
end
