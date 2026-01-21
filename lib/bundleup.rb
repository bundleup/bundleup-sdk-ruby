# frozen_string_literal: true

require 'faraday'
require 'faraday/retry'
require 'json'

require_relative 'bundleup/version'
require_relative 'bundleup/errors'
require_relative 'bundleup/base'
require_relative 'bundleup/client'
require_relative 'bundleup/connection'
require_relative 'bundleup/integration'
require_relative 'bundleup/webhook'
require_relative 'bundleup/proxy'
require_relative 'bundleup/unify/base'
require_relative 'bundleup/unify/chat'
require_relative 'bundleup/unify/git'
require_relative 'bundleup/unify/pm'

# BundleUp Ruby SDK
#
# Official Ruby client library for the BundleUp API
module Bundleup
  class << self
    # Create a new BundleUp client
    #
    # @param api_key [String] Your BundleUp API key
    # @return [Bundleup::Client] A new client instance
    def new(api_key)
      Client.new(api_key)
    end
  end
end
