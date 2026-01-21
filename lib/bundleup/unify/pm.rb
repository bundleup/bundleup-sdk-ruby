# frozen_string_literal: true

module Bundleup
  module Unify
    # PM (Project Management) resource for unified project management operations
    class PM < Base
      # List issues
      #
      # @param params [Hash] Query parameters
      # @option params [Integer] :limit Number of results to return
      # @option params [String] :cursor Pagination cursor
      # @option params [Boolean] :include_raw Include raw response from the integration
      # @return [Hash] Issues data with pagination info
      def issues(params = {})
        include_raw = params.delete(:include_raw) || false
        request(:get, "/#{API_VERSION}/pm/issues", params, include_raw: include_raw)
      end
    end
  end
end
