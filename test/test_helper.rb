$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

class NullObject
  def method_missing(*_args)
    self
  end
end

require 'bundler/setup'
require 'support/simplecov'
require 'scorched_earth'
require 'minitest/autorun'
