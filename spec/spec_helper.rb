$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'rails/all'
require 'jsonapi-resources'
require "jsonapi/resources/coercion"

require File.expand_path("../support/resources/book_resource.rb", __FILE__)