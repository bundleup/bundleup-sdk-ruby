# frozen_string_literal: true

module Bundleup
  # Base error class for all BundleUp errors
  class Error < StandardError; end

  # Raised when an API error occurs
  class APIError < Error; end

  # Raised when authentication fails
  class AuthenticationError < Error; end

  # Raised when a request is invalid
  class InvalidRequestError < Error; end
end
