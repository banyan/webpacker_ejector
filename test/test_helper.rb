ENV["RAILS_ENV"] = ENV["RACK_ENV"] = "test"
$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require File.expand_path("../../test/sample/config/environment.rb", __FILE__)

require "rails/test_help"
require "webpacker_ejector"
require "minitest/autorun"
require "minitest/pride"
require 'minitest/hooks/test'
