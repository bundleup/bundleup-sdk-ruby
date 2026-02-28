# frozen_string_literal: true

module BundleUp
  module Resources
    # Base class for API resources.
    class Base
      BASE_URL = 'https://api.bundleup.io'
      API_VERSION = 'v1'

      def initialize(api_key)
        @api_key = api_key
      end

      protected

      def list(params: {})
        response = connection.get(resource_name, params)

        raise "Failed to fetch #{resource_name}: #{response.status}: #{response.body}" unless response.success?

        response.body
      end

      def create(body: {})
        response = connection.post(resource_name, body.to_json)

        raise "Failed to create #{resource_name}: #{response.status}" unless response.success?

        response.body
      end

      def retrieve(id)
        response = connection.get("#{resource_name}/#{id}")

        raise "Failed to retrieve #{resource_name}: #{response.status}" unless response.success?

        response.body
      end

      def update(id, body: {})
        response = connection.put("#{resource_name}/#{id}", body.to_json)

        raise "Failed to update #{resource_name}: #{response.status}" unless response.success?

        response.body
      end

      def delete(id)
        response = connection.delete("#{resource_name}/#{id}")

        raise "Failed to delete #{resource_name}: #{response.status}" unless response.success?

        nil
      end

      private

      # Memoize the Faraday connection to reuse it across requests
      def connection
        @connection ||= Faraday.new(url: "#{BASE_URL}/#{API_VERSION}/") do |faraday|
          faraday.headers = {
            'Authorization' => "Bearer #{@api_key}",
            'Content-Type' => 'application/json'
          }

          faraday.request :json
          faraday.response :json, content_type: /\bjson$/
          faraday.response :raise_error
          faraday.adapter Faraday.default_adapter
        end
      end

      def resource_name
        raise NotImplementedError, 'Subclasses must implement the resource_name method'
      end
    end
  end
end
