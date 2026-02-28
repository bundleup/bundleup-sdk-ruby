# frozen_string_literal: true

module BundleUp
  # Client for core BundleUp API resources.
  class Client
    attr_reader :api_key

    def initialize(api_key)
      raise ArgumentError, 'API key is required to initialize BundleUp SDK.' if api_key.nil? || api_key.empty?

      @api_key = api_key
    end

    def connections
      @connections ||= BundleUp::Resources::Connection.new(@api_key)
    end

    def integrations
      @integrations ||= BundleUp::Resources::Integration.new(@api_key)
    end

    def webhooks
      @webhooks ||= BundleUp::Resources::Webhook.new(@api_key)
    end

    def proxy(connection_id)
      if connection_id.nil? || connection_id.empty?
        raise ArgumentError, 'Connection ID is required to create a Proxy instance.'
      end

      BundleUp::Proxy.new(@api_key, connection_id)
    end

    def unify(connection_id)
      if connection_id.nil? || connection_id.empty?
        raise ArgumentError, 'Connection ID is required to create a Unify instance.'
      end

      BundleUp::Unify::Client.new(@api_key, connection_id)
    end
  end
end
