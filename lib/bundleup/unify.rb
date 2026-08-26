# frozen_string_literal: true

module BundleUp
  module Unify
    # Client for Unify API endpoints.
    class Client
      attr_reader :api_key, :connection_id

      def initialize(api_key, connection_id)
        @ticketing = BundleUp::Unify::Ticketing.new(api_key, connection_id)
        @chat = BundleUp::Unify::Chat.new(api_key, connection_id)
        @git = BundleUp::Unify::Git.new(api_key, connection_id)
        @crm = BundleUp::Unify::CRM.new(api_key, connection_id)
        @drive = BundleUp::Unify::Drive.new(api_key, connection_id)
        @calendar = BundleUp::Unify::Calendar.new(api_key, connection_id)
        @api_key = api_key
        @connection_id = connection_id
      end

      # Access the Chat API for the connection.
      def chat
        @chat ||= BundleUp::Unify::Chat.new(api_key, connection_id)
      end

      # Access the Git API for the connection.
      def git
        @git ||= BundleUp::Unify::Git.new(api_key, connection_id)
      end

      # Access the CRM API for the connection.
      def crm
        @crm ||= BundleUp::Unify::CRM.new(api_key, connection_id)
      end

      # Access the Ticketing API for the connection.
      def ticketing
        @ticketing ||= BundleUp::Unify::Ticketing.new(api_key, connection_id)
      end

      # Access the Drive API for the connection.
      def drive
        @drive ||= BundleUp::Unify::Drive.new(api_key, connection_id)
      end

      # Access the Calendar API for the connection.
      def calendar
        @calendar ||= BundleUp::Unify::Calendar.new(api_key, connection_id)
      end

      # Fetch the account this connection is authenticated as.
      #
      # `me` is the one unified method every provider implements, so it hangs off
      # the Unify client directly instead of a vertical namespace.
      def me(params = {})
        (@me ||= BundleUp::Unify::Me.new(api_key, connection_id)).get(params)
      end

      # Access the Unified MCP server for the connection.
      def mcp
        @mcp ||= BundleUp::Unify::MCP.new(api_key, connection_id)
      end
    end
  end
end
