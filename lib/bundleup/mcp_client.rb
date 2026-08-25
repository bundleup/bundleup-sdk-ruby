# frozen_string_literal: true

require 'json'

module BundleUp
  # A connected MCP session.
  #
  # Tools, resources and prompts are defined by the provider — BundleUp does
  # not rename or normalize them.
  class MCPClient
    PROTOCOL_VERSION = '2025-06-18'
    CLIENT_NAME = 'bundleup-sdk'

    def initialize(base_url, api_key, connection_id)
      @base_url = base_url
      @api_key = api_key
      @connection_id = connection_id
      @session_id = nil
      @connected = false
      @last_id = 0
    end

    # List the provider's tools, following pagination to the end.
    def tools
      paginate('tools/list', 'tools')
    end

    # Call a tool by name, with arguments matching its own input schema.
    def tool(name, args = {})
      raise ArgumentError, 'Tool name is required to call a tool.' if blank?(name)

      connect
      send_message('tools/call', { name: name, arguments: args })
    end

    # List the provider's resources, following pagination to the end.
    def resources
      paginate('resources/list', 'resources')
    end

    # Read a resource by URI.
    def resource(uri)
      raise ArgumentError, 'Resource URI is required to read a resource.' if blank?(uri)

      connect
      send_message('resources/read', { uri: uri })
    end

    # List the provider's prompts, following pagination to the end.
    def prompts
      paginate('prompts/list', 'prompts')
    end

    # Get a prompt by name.
    def prompt(name, args = {})
      raise ArgumentError, 'Prompt name is required to get a prompt.' if blank?(name)

      connect
      send_message('prompts/get', { name: name, arguments: args })
    end

    # Send any other JSON-RPC method on this session.
    def request(method, params = nil)
      raise ArgumentError, 'Method is required to send a request.' if blank?(method)

      connect
      send_message(method, params)
    end

    # End the session and reset local state.
    def close
      delete_session if @session_id

      @session_id = nil
      @connected = false
      nil
    end

    private

    def blank?(value)
      value.nil? || value.to_s.empty?
    end

    def default_headers
      headers = {
        'Authorization' => "******",
        'Content-Type' => 'application/json',
        'Accept' => 'application/json, text/event-stream',
        'BU-Connection-Id' => @connection_id
      }
      headers['Mcp-Session-Id'] = @session_id if @session_id
      headers
    end

    def connection
      @connection ||= Faraday.new { |faraday| faraday.adapter Faraday.default_adapter }
    end

    def post_payload(payload)
      response = connection.post(@base_url, payload.to_json, default_headers)
      session_id = response.headers['mcp-session-id']
      @session_id = session_id if session_id

      raise error_for(response) unless response.success?

      response
    end

    def error_for(response)
      fallback = "MCP request failed with status #{response.status}."
      parsed = JSON.parse(response.body.to_s)
      return RuntimeError.new(fallback) unless parsed.is_a?(Hash) && parsed['message']

      code = parsed['code']
      RuntimeError.new(code ? "#{parsed['message']} (#{code})" : parsed['message'])
    rescue JSON::ParserError
      RuntimeError.new(fallback)
    end

    # Run the MCP handshake, once. Deferred until the first call.
    def connect
      return if @connected

      send_message('initialize', handshake_params)
      post_payload({ jsonrpc: '2.0', method: 'notifications/initialized' })
      @connected = true
    end

    def handshake_params
      {
        protocolVersion: PROTOCOL_VERSION,
        capabilities: {},
        clientInfo: { name: CLIENT_NAME, version: BundleUp::VERSION }
      }
    end

    def send_message(method, params = nil)
      @last_id += 1
      payload = { jsonrpc: '2.0', id: @last_id, method: method }
      payload[:params] = params unless params.nil?

      message = parse(post_payload(payload), @last_id)
      raise "No response received for #{method}." if message.nil?
      raise message['error']['message'].to_s if message['error']

      message['result'] || {}
    end

    # Providers may answer a plain request/response over text/event-stream.
    def parse(response, message_id)
      body = response.body.to_s
      return nil if body.empty?

      content_type = response.headers['content-type'].to_s
      return JSON.parse(body) unless content_type.include?('text/event-stream')

      parse_stream(body, message_id)
    end

    def parse_stream(body, message_id)
      body.gsub("\r\n", "\n").split("\n\n").each do |event|
        data = event_data(event)
        next if data.empty?

        message = JSON.parse(data)
        # Skip server notifications interleaved on the stream.
        return message if message.is_a?(Hash) && message['id'] == message_id
      end

      nil
    end

    def event_data(event)
      event.split("\n")
           .select { |line| line.start_with?('data:') }
           .map { |line| line.sub('data:', '').strip }
           .join("\n")
    end

    def paginate(method, key)
      connect
      items = []
      cursor = nil

      loop do
        result = send_message(method, cursor ? { cursor: cursor } : nil)
        items.concat(result[key] || [])
        cursor = result['nextCursor']
        break unless cursor
      end

      items
    end

    def delete_session
      connection.delete(@base_url, nil, default_headers)
    rescue Faraday::Error
      nil
    end
  end
end
