# frozen_string_literal: true

require 'faraday'

require_relative 'bundleup/version'
require_relative 'bundleup/client'
require_relative 'bundleup/proxy'
require_relative 'bundleup/unify'

# Resources
require_relative 'bundleup/resources/base'
require_relative 'bundleup/resources/connection'
require_relative 'bundleup/resources/integration'
require_relative 'bundleup/resources/webhook'

# Unify endpoints
require_relative 'bundleup/unify/base'
require_relative 'bundleup/unify/chat'
require_relative 'bundleup/unify/git'
require_relative 'bundleup/unify/pm'

# Main module for the BundleUp SDK.
module Bundleup
end
