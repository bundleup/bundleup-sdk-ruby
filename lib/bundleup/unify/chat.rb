# frozen_string_literal: true

module BundleUp
  module Unify
    # Client for chat-related Unify endpoints.
    class Chat < Base
      # Fetches channels from the connected chat provider.
      def channels(params = {})
        response = connection.get('chat/channels') do |req|
          req.params = params
        end

        raise "Failed to fetch chat/channels: #{response.status}" unless response.success?

        response.body
      end
    end
  end
end
