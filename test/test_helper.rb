$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "wrapper_based"
require "minitest/autorun"
require 'mocha/mini_test'

def assert_unknown_role(role, &blk)
  error = assert_raises(WrapperBased::RoleUnknown, &blk)
  assert_match /^unknown role `#{role}' for /, error.message
end
