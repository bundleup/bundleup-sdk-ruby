# frozen_string_literal: true

module BundleUp
  module Unify
    # Client for Unify API endpoints.
    class Client
      attr_reader :api_key, :connection_id

      def initialize(api_key, connection_id)
        @pm = BundleUp::Unify::PM.new(api_key, connection_id)
        @chat = BundleUp::Unify::Chat.new(api_key, connection_id)
        @git = BundleUp::Unify::Git.new(api_key, connection_id)
      end
    end
  end
end
