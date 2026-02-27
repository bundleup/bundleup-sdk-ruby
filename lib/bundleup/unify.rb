# frozen_string_literal: true

module Bundleup
  module Unify
    # Client for Unify API endpoints.
    class Client
      attr_reader :api_key, :connection_id

      def initialize(api_key, connection_id)
        @pm = Bundleup::Unify::PM.new(api_key, connection_id)
        @chat = Bundleup::Unify::Chat.new(api_key, connection_id)
        @git = Bundleup::Unify::Git.new(api_key, connection_id)
      end
    end
  end
end
