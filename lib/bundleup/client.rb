# frozen_string_literal: true

module Bundleup
  # Main client class for interacting with the BundleUp API
  class Client
    attr_reader :api_key

    # Initialize a new BundleUp client
    #
    # @param api_key [String] Your BundleUp API key
    # @raise [ArgumentError] if api_key is nil or empty
    def initialize(api_key)
      raise ArgumentError, 'API key is required to initialize BundleUp SDK.' if api_key.nil? || api_key.to_s.empty?

      @api_key = api_key
    end

    # Access the Connections resource
    #
    # @return [Bundleup::Connection] Connection resource instance
    def connections
      @connections ||= Bundleup::Connection.new(@api_key)
    end

    # Access the Integrations resource
    #
    # @return [Bundleup::Integration] Integration resource instance
    def integrations
      @integrations ||= Bundleup::Integration.new(@api_key)
    end

    # Access the Webhooks resource
    #
    # @return [Bundleup::Webhook] Webhook resource instance
    def webhooks
      @webhooks ||= Bundleup::Webhook.new(@api_key)
    end

    # Create a Proxy instance for a specific connection
    #
    # @param connection_id [String] The connection ID
    # @return [Bundleup::Proxy] Proxy instance
    # @raise [ArgumentError] if connection_id is nil or empty
    def proxy(connection_id)
      if connection_id.nil? || connection_id.to_s.empty?
        raise ArgumentError,
              'Connection ID is required to create a Proxy instance.'
      end

      Bundleup::Proxy.new(@api_key, connection_id)
    end

    # Create Unify instances for a specific connection
    #
    # @param connection_id [String] The connection ID
    # @return [Hash] Hash with :chat, :git, and :pm Unify instances
    # @raise [ArgumentError] if connection_id is nil or empty
    def unify(connection_id)
      if connection_id.nil? || connection_id.to_s.empty?
        raise ArgumentError,
              'Connection ID is required to create a Unify instance.'
      end

      {
        chat: Bundleup::Unify::Chat.new(@api_key, connection_id),
        git: Bundleup::Unify::Git.new(@api_key, connection_id),
        pm: Bundleup::Unify::PM.new(@api_key, connection_id)
      }
    end
  end
end
