# frozen_string_literal: true

module Bundleup
  # Base class for all BundleUp resources
  class Base
    BASE_URL = 'https://api.bundleup.io'
    API_VERSION = 'v1'

    attr_reader :api_key

    def initialize(api_key)
      @api_key = api_key
    end

    # List all resources
    #
    # @param params [Hash] Query parameters
    # @return [Hash] Response with data and pagination info
    def list(params = {})
      request(:get, resource_path, params)
    end

    # Create a new resource
    #
    # @param data [Hash] Resource data
    # @return [Hash] Created resource
    def create(data)
      request(:post, resource_path, data)
    end

    # Retrieve a specific resource
    #
    # @param id [String] Resource ID
    # @return [Hash] Resource data
    def retrieve(id)
      request(:get, "#{resource_path}/#{id}")
    end

    # Update a resource
    #
    # @param id [String] Resource ID
    # @param data [Hash] Updated resource data
    # @return [Hash] Updated resource
    def update(id, data)
      request(:patch, "#{resource_path}/#{id}", data)
    end

    # Delete a resource
    #
    # @param id [String] Resource ID
    # @return [Hash] Deletion response
    def delete(id)
      request(:delete, "#{resource_path}/#{id}")
    end

    private

    def resource_path
      "/#{API_VERSION}/#{resource_name}"
    end

    def resource_name
      raise NotImplementedError, 'Subclasses must implement resource_name'
    end

    def request(method, path, body = nil)
      url = "#{BASE_URL}#{path}"
      
      response = connection.public_send(method) do |req|
        req.url path
        req.headers['Content-Type'] = 'application/json'
        req.headers['Authorization'] = "Bearer #{api_key}"
        req.body = body.to_json if body && %i[post patch put].include?(method)
        req.params.update(body) if body && method == :get
      end

      handle_response(response)
    rescue Faraday::Error => e
      raise APIError, "Request failed: #{e.message}"
    end

    def connection
      @connection ||= Faraday.new(url: BASE_URL) do |conn|
        conn.request :retry, max: 3, interval: 0.5, backoff_factor: 2
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
