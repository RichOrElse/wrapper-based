require "type_wrapper"

module DCI
  Module = Class.new(TypeWrapper::Module)

  @@context_producer = WrapperBased::Context::Producer.new(TypeWrapper)

  def self.Context(*args, &block)
    @@context_producer.produce(*args, &block)
  end
end
