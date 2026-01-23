# frozen_string_literal: true

module Bundleup
  module Unify
    # Base class for all Unify resources
    class Base
      BASE_URL = 'https://unify.bundleup.io'
      API_VERSION = 'v1'

      attr_reader :api_key, :connection_id

      # Initialize a new Unify resource
      #
      # @param api_key [String] Your BundleUp API key
      # @param connection_id [String] The connection ID
      def initialize(api_key, connection_id)
        @api_key = api_key
        @connection_id = connection_id
      end

      private

      def request(method, path, params = {}, include_raw: false)
        response = connection.public_send(method) do |req|
          req.url path
          req.headers['Content-Type'] = 'application/json'
          req.headers['Authorization'] = "Bearer #{api_key}"
          req.headers['BU-Connection-Id'] = connection_id
          req.headers['BU-Include-Raw'] = include_raw.to_s

          if params && %i[post patch put].include?(method)
            req.body = params.to_json
          elsif params && method == :get
            req.params.update(params)
          end
        end

        handle_response(response)
      rescue Faraday::Error => e
        raise APIError, "Unify request failed: #{e.message}"
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
end
