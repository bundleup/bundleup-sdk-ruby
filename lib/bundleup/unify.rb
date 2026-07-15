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
    end
  end
end
