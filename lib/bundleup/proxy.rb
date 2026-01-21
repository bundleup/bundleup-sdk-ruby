# frozen_string_literal: true

module Bundleup
  # Proxy class for making direct calls to integration APIs
  class Proxy
    BASE_URL = 'https://proxy.bundleup.io'

    attr_reader :api_key, :connection_id

    # Initialize a new Proxy instance
    #
    # @param api_key [String] Your BundleUp API key
    # @param connection_id [String] The connection ID
    def initialize(api_key, connection_id)
      @api_key = api_key
      @connection_id = connection_id
    end

    # Make a GET request
    #
    # @param path [String] The request path
    # @param params [Hash] Query parameters
    # @return [Hash] Response data
    def get(path, params = {})
      request(:get, path, params)
    end

    # Make a POST request
    #
    # @param path [String] The request path
    # @param body [Hash] Request body
    # @return [Hash] Response data
    def post(path, body = {})
      request(:post, path, body)
    end

    # Make a PUT request
    #
    # @param path [String] The request path
    # @param body [Hash] Request body
    # @return [Hash] Response data
    def put(path, body = {})
      request(:put, path, body)
    end

    # Make a PATCH request
    #
    # @param path [String] The request path
    # @param body [Hash] Request body
    # @return [Hash] Response data
    def patch(path, body = {})
      request(:patch, path, body)
    end

    # Make a DELETE request
    #
    # @param path [String] The request path
    # @param params [Hash] Query parameters
    # @return [Hash] Response data
    def delete(path, params = {})
      request(:delete, path, params)
    end

    private

    def request(method, path, body = nil)
      response = connection.public_send(method) do |req|
        req.url path
        req.headers['Content-Type'] = 'application/json'
        req.headers['Authorization'] = "Bearer #{api_key}"
        req.headers['BU-Connection-Id'] = connection_id
        
        if body && %i[post patch put].include?(method)
          req.body = body.to_json
        elsif body && method == :get
          req.params.update(body)
        end
      end

      handle_response(response)
    rescue Faraday::Error => e
      raise APIError, "Proxy request failed: #{e.message}"
    end

    def connection
      @connection ||= Faraday.new(url: BASE_URL) do |conn|
        conn.request :retry, max: 3, interval: 0.5, backoff_factor: 2
        conn.response :raise_error
        conn.adapter Faraday.default_adapter
      end
    end

    def handle_response(response)
      case response.status
      when 200..299
        response.body.empty? ? {} : JSON.parse(response.body)
      when 401
        raise AuthenticationError, 'Invalid API key'
      when 400..499
        error_message = extract_error_message(response)
        raise InvalidRequestError, error_message
      when 500..599
        raise APIError, 'Server error occurred'
      else
        raise APIError, "Unexpected response status: #{response.status}"
      end
    end

    def extract_error_message(response)
      body = JSON.parse(response.body)
      body['error'] || body['message'] || "Request failed with status #{response.status}"
    rescue JSON::ParserError
      "Request failed with status #{response.status}"
    end
  end
end
