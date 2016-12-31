$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'bundler/setup'
require 'support/simplecov'
require 'support/null_object'
require 'scorched_earth'
require 'minitest/autorun'
