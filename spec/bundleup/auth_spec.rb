# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BundleUp::Auth do
  let(:api_key) { 'test_api_key' }
  let(:instance) { described_class.new(api_key) }
  let(:redirect_uri) { 'https://app.example.com/callback' }
  let(:exchange_url) { 'https://auth.bundleup.io/connection' }

  describe 'BundleUp::Client#auth' do
    it 'returns a memoized Auth instance' do
      client = BundleUp::Client.new(api_key)

      expect(client.auth).to be_a(described_class)
      expect(client.auth).to be(client.auth)
    end
  end

  describe '#build_authorization_url' do
    let(:required) { { client_id: 'client_123', integration_id: 'github', redirect_uri: redirect_uri } }

    it 'builds the authorize URL with required params' do
      uri = URI.parse(instance.build_authorization_url(**required))
      query = URI.decode_www_form(uri.query).to_h

      expect("#{uri.scheme}://#{uri.host}#{uri.path}").to eq('https://auth.bundleup.io/authorize')
      expect(query).to eq(
        'client_id' => 'client_123',
        'integration_id' => 'github',
        'redirect_uri' => redirect_uri
      )
    end

    it 'includes external_id and state when given' do
      url = instance.build_authorization_url(**required, external_id: 'user_42', state: 'xyz')
      query = URI.decode_www_form(URI.parse(url).query).to_h

      expect(query['external_id']).to eq('user_42')
      expect(query['state']).to eq('xyz')
    end

    %i[client_id integration_id redirect_uri].each do |key|
      it "raises when #{key} is missing" do
        expect do
          instance.build_authorization_url(**required, key => '')
        end.to raise_error(ArgumentError, "#{key} is required")
      end
    end
  end

  describe '#get_connection_from_code' do
    it 'POSTs the code and redirect_uri with the API key' do
      stub = stub_request(:post, exchange_url)
             .with(
               body: { code: 'code_abc', redirect_uri: redirect_uri }.to_json,
               headers: {
                 'Authorization' => "Bearer #{api_key}",
                 'Content-Type' => 'application/json'
               }
             )
             .to_return(
               status: 200,
               body: '{"connection_id":"conn_1","external_id":"user_42","integration_id":"github"}',
               headers: { 'Content-Type' => 'application/json' }
             )

      result = instance.get_connection_from_code(code: 'code_abc', redirect_uri: redirect_uri)

      expect(result).to eq(
        'connection_id' => 'conn_1',
        'external_id' => 'user_42',
        'integration_id' => 'github'
      )
      expect(stub).to have_been_requested
    end

    it 'raises with the error body on failure' do
      stub_request(:post, exchange_url)
        .to_return(
          status: 400,
          body: '{"errors":{"code":["Invalid or expired authorization code"]}}',
          headers: { 'Content-Type' => 'application/json' }
        )

      expect do
        instance.get_connection_from_code(code: 'bad', redirect_uri: redirect_uri)
      end.to raise_error(RuntimeError, /400: .*Invalid or expired authorization code/)
    end

    it 'raises when code is missing' do
      expect do
        instance.get_connection_from_code(code: '', redirect_uri: redirect_uri)
      end.to raise_error(ArgumentError, 'code is required')
    end

    it 'raises when redirect_uri is missing' do
      expect do
        instance.get_connection_from_code(code: 'code_abc', redirect_uri: '')
      end.to raise_error(ArgumentError, 'redirect_uri is required')
    end
  end
end
