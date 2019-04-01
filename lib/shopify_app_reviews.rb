
require 'pry'
require 'nokogiri'
require 'open-uri'
# require 'colorize'

module Concerns
  require_relative "../lib/concerns/findable.rb"
  require_relative "../lib/concerns/methods.rb"
end

require_relative "shopify_app_reviews/version"
require_relative './shopify_app_reviews/cli'
