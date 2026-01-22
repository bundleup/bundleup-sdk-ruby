# frozen_string_literal: true

module Bundleup
  module Unify
    # Chat resource for unified chat operations
    class Chat < Base
      # List channels
      #
      # @param params [Hash] Query parameters
      # @option params [Integer] :limit Number of results to return
      # @option params [String] :cursor Pagination cursor
      # @option params [Boolean] :include_raw Include raw response from the integration
      # @return [Hash] Channels data with pagination info
      def channels(params = {})
        include_raw = params.delete(:include_raw) || false
        request(:get, "/#{API_VERSION}/chat/channels", params, include_raw: include_raw)
      end
    end
  end
end
