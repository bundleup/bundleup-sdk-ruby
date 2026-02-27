# frozen_string_literal: true

module Bundleup
  # Client for proxy API requests.
  class Proxy
    BASE_URL = 'https://proxy.bundleup.io'

    attr_reader :api_key, :connection_id

    def initialize(api_key, connection_id)
      @api_key = api_key
      @connection_id = connection_id
    end

    def get(path, headers: {})
      raise ArgumentError, 'Path is required for GET request' unless path

      # Merge any additional headers
      request_headers = connection.headers.merge(headers)
      connection.get(path, nil, request_headers)
    end

    def post(path, body: {}, headers: {})
      raise ArgumentError, 'Path is required for POST request' unless path

      # Merge any additional headers
      request_headers = connection.headers.merge(headers)
      connection.post(path, body.to_json, request_headers)
    end

    def put(path, body: {}, headers: {})
      raise ArgumentError, 'Path is required for PUT request' unless path

      # Merge any additional headers
      request_headers = connection.headers.merge(headers)
      connection.put(path, body.to_json, request_headers)
    end

    def patch(path, body: {}, headers: {})
      raise ArgumentError, 'Path is required for PATCH request' unless path

      # Merge any additional headers
      request_headers = connection.headers.merge(headers)
      connection.patch(path, body.to_json, request_headers)
    end

    def delete(path, headers: {})
      raise ArgumentError, 'Path is required for DELETE request' unless path

      # Merge any additional headers
      request_headers = connection.headers.merge(headers)
      connection.delete(path, nil, request_headers)
    end

    private

    # Memoize the Faraday connection to reuse it across requests
    def connection
      @connection ||= Faraday.new(url: BASE_URL) do |faraday|
        faraday.headers = {
          'Authorization' => "Bearer #{@api_key}",
          'Content-Type' => 'application/json',
          'BU-Connection-Id' => @connection_id
        }

        faraday.request :json
        faraday.response :json, content_type: /\bjson$/
        faraday.response :raise_error
        faraday.adapter Faraday.default_adapter
      end
    end
  end
end
