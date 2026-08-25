# frozen_string_literal: true

require 'json'
require_relative 'mcp_client'

module BundleUp
  # Transport for a connection's MCP server.
  #
  # +post+ and +delete+ return the raw Faraday response, the way Proxy does.
  # Use +connect+ for a managed session that handles the handshake and
  # response decoding.
  class MCP
    BASE_URL = 'https://mcp.bundleup.io'

    # Separates the API key from an appended connection ID. Safe to split on:
    # API keys are alphanumeric and connection IDs are cuids.
    CREDENTIAL_SEPARATOR = '.'

    attr_reader :api_key, :connection_id

    def initialize(api_key, connection_id)
      @api_key = api_key
      @connection_id = connection_id
    end

    # The URL and headers for an MCP client running in your own process.
    def transport
      { url: BASE_URL, headers: default_headers }
    end

    # The URL and a single bearer token carrying both the API key and the
    # connection, for model-hosted MCP clients that cannot set custom headers.
    # Note this hands your API key to the model provider.
    def hosted
      { url: BASE_URL, token: "#{@api_key}#{CREDENTIAL_SEPARATOR}#{@connection_id}" }
    end

    # Send a JSON-RPC message and return the raw response. Pass
    # +Mcp-Session-Id+ in +headers+ to stay on an existing session.
    def post(body, headers: {})
      payload = body.is_a?(String) ? body : body.to_json

      connection.post(BASE_URL, payload, default_headers.merge(headers))
    end

    # End an MCP session. Pass the session's +Mcp-Session-Id+ in +headers+.
    def delete(headers: {})
      connection.delete(BASE_URL, nil, default_headers.merge(headers))
    end

    # Open a managed MCP session for this connection.
    def connect
      MCPClient.new(BASE_URL, @api_key, @connection_id)
    end

    private

    def default_headers
      {
        'Authorization' => "Bearer #{@api_key}",
        'Content-Type' => 'application/json',
        'Accept' => 'application/json, text/event-stream',
        'BU-Connection-Id' => @connection_id
      }
    end

    def connection
      @connection ||= Faraday.new { |faraday| faraday.adapter Faraday.default_adapter }
    end
  end
end
