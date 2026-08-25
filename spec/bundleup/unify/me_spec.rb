# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BundleUp::Unify::Me do
  let(:api_key) { 'test_api_key' }
  let(:connection_id) { 'conn_123' }
  let(:instance) { described_class.new(api_key, connection_id) }
  let(:base_url) { 'https://unify.bundleup.io/v1' }
  let(:body) { '{"data":{"id":"u_1","name":"Ada","email":"ada@acme.io","avatar_url":null}}' }

  describe '#get' do
    it 'makes a GET request to the root me endpoint' do
      stub = stub_request(:get, "#{base_url}/me")
             .with(
               headers: {
                 'Authorization' => "Bearer #{api_key}",
                 'Content-Type' => 'application/json',
                 'BU-Connection-Id' => connection_id
               }
             )
             .to_return(
               status: 200,
               body: body,
               headers: { 'Content-Type' => 'application/json' }
             )

      result = instance.get
      expect(result).to eq(
        { 'data' => { 'id' => 'u_1', 'name' => 'Ada', 'email' => 'ada@acme.io', 'avatar_url' => nil } }
      )
      expect(stub).to have_been_requested
    end

    it 'passes params through' do
      stub = stub_request(:get, "#{base_url}/me")
             .with(query: { 'include_raw' => 'true' })
             .to_return(
               status: 200,
               body: body,
               headers: { 'Content-Type' => 'application/json' }
             )

      instance.get(include_raw: true)

      expect(stub).to have_been_requested
    end

    it 'raises error on 401' do
      stub_request(:get, "#{base_url}/me")
        .to_return(status: 401, body: '{"error":"Unauthorized"}')

      expect { instance.get }.to raise_error(Faraday::UnauthorizedError)
    end
  end
end
