# frozen_string_literal: true

require 'uri'

module BundleUp
  # Client for the hosted authorization flow.
  class Auth
    BASE_URL = 'https://auth.bundleup.io'

    attr_reader :api_key

    def initialize(api_key)
      @api_key = api_key
    end

    # Builds the hosted authorization URL to send the end user to.
    def build_authorization_url(client_id:, integration_id:, redirect_uri:, external_id: nil, state: nil)
      raise ArgumentError, 'client_id is required' if blank?(client_id)
      raise ArgumentError, 'integration_id is required' if blank?(integration_id)
      raise ArgumentError, 'redirect_uri is required' if blank?(redirect_uri)

      params = {
        client_id: client_id,
        integration_id: integration_id,
        redirect_uri: redirect_uri
      }
      params[:external_id] = external_id unless blank?(external_id)
      params[:state] = state unless blank?(state)

      "#{BASE_URL}/authorize?#{URI.encode_www_form(params)}"
    end

    # Exchanges the one-time code from the redirect for the connection.
    # Call this server-side; the code expires after 5 minutes and works once.
    # Returns { 'connection_id', 'external_id', 'integration_id' }.
    def get_connection_from_code(code:, redirect_uri:)
      raise ArgumentError, 'code is required' if blank?(code)
      raise ArgumentError, 'redirect_uri is required' if blank?(redirect_uri)

      response = connection.post('connection', { code: code, redirect_uri: redirect_uri })

      raise "Failed to get connection: #{response.status}: #{response.body}" unless response.success?

      response.body
    end

    private

    def blank?(value)
      value.nil? || value.to_s.empty?
    end

    # Memoize the Faraday connection to reuse it across requests
    def connection
      @connection ||= Faraday.new(url: BASE_URL) do |faraday|
        faraday.headers = {
          'Authorization' => "Bearer #{@api_key}",
          'Content-Type' => 'application/json'
        }

        faraday.request :json
        faraday.response :json, content_type: /\bjson$/
        faraday.adapter Faraday.default_adapter
      end
    end
  end
end
