# frozen_string_literal: true

module BundleUp
  module Unify
    # The Unified MCP server.
    #
    # Same protocol and headers as Proxy MCP, but the tools are BundleUp's
    # normalized ones rather than the provider's. Tools only — Unified MCP
    # exposes no resources or prompts.
    #
    # The server is stateless and POST-only, so there is no session to close.
    class MCP
      BASE_URL = 'https://unify.bundleup.io/v1/mcp'

      attr_reader :api_key, :connection_id

      def initialize(api_key, connection_id)
        @api_key = api_key
        @connection_id = connection_id
        @client = ::BundleUp::MCPClient.new(BASE_URL, api_key, connection_id)
      end

      # The URL and a single bearer token carrying both the API key and the
      # connection, for model-hosted MCP clients that cannot set headers.
      def hosted
        separator = ::BundleUp::MCP::CREDENTIAL_SEPARATOR

        { url: BASE_URL, token: "#{@api_key}#{separator}#{@connection_id}" }
      end

      # List the available unified tools.
      def list_tools
        @client.list_tools
      end

      # Call a unified tool with optional arguments.
      def call_tool(name, args = {})
        raise ArgumentError, 'Tool name is required to call a tool.' if name.nil? || name.to_s.empty?

        @client.call_tool(name, args)
      end
    end
  end
end
