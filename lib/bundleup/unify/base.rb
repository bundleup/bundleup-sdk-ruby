# frozen_string_literal: true

module Bundleup
  module Unify
    # Base class for Unify API clients.
    class Base
      BASE_URL = 'https://unify.bundleup.io'
      API_VERSION = 'v1'

      attr_reader :api_key, :connection_id

      def initialize(api_key, connection_id)
        @api_key = api_key
        @connection_id = connection_id
      end

      private

      # Memoize the Faraday connection to reuse it across requests
      def connection
        @connection ||= Faraday.new(url: "#{BASE_URL}/#{API_VERSION}/") do |faraday|
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
end
