# frozen_string_literal: true

require 'faraday'

require_relative 'bundleup/version'
require_relative 'bundleup/client'
require_relative 'bundleup/auth'
require_relative 'bundleup/proxy'
require_relative 'bundleup/unify'
require_relative 'bundleup/mcp'

# Resources
require_relative 'bundleup/resources/base'
require_relative 'bundleup/resources/connection'
require_relative 'bundleup/resources/integration'
require_relative 'bundleup/resources/webhook'

# Unify endpoints
require_relative 'bundleup/unify/base'
require_relative 'bundleup/unify/chat'
require_relative 'bundleup/unify/git'
require_relative 'bundleup/unify/tasks'
require_relative 'bundleup/unify/helpdesk'
require_relative 'bundleup/unify/crm'
require_relative 'bundleup/unify/drive'
require_relative 'bundleup/unify/calendar'
require_relative 'bundleup/unify/me'

# Main module for the BundleUp SDK.
module BundleUp
  # Builds the hosted authorization URL without an API key.
  # See BundleUp::Auth.build_authorization_url.
  def self.build_authorization_url(**params)
    Auth.build_authorization_url(**params)
  end
end
