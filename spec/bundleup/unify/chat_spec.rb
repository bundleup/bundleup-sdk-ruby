# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Bundleup::Unify::Chat do
  let(:api_key) { 'test_api_key' }
  let(:connection_id) { 'conn_123' }
  let(:instance) { described_class.new(api_key, connection_id) }
  let(:base_url) { 'https://unify.bundleup.io/v1' }

  describe '#channels' do
    it 'makes a GET request to channels endpoint' do
      stub = stub_request(:get, "#{base_url}/chat/channels")
             .with(
               headers: {
                 'Authorization' => "Bearer #{api_key}",
                 'Content-Type' => 'application/json',
                 'BU-Connection-Id' => connection_id
               }
             )
             .to_return(
               status: 200,
               body: '{"data":[{"id":"ch_1","name":"general"}]}',
               headers: { 'Content-Type' => 'application/json' }
             )

      result = instance.channels
      expect(result).to eq({ 'data' => [{ 'id' => 'ch_1', 'name' => 'general' }] })
      expect(stub).to have_been_requested
    end

    it 'supports additional query parameters' do
      stub = stub_request(:get, "#{base_url}/chat/channels?limit=10")
             .with(
               headers: {
                 'Authorization' => "Bearer #{api_key}",
                 'Content-Type' => 'application/json',
                 'BU-Connection-Id' => connection_id
               }
             )
             .to_return(
               status: 200,
               body: '{"data":[]}',
               headers: { 'Content-Type' => 'application/json' }
             )

      instance.channels(limit: 10)
      expect(stub).to have_been_requested
    end

    it 'raises error on 401' do
      stub_request(:get, "#{base_url}/chat/channels")
        .to_return(status: 401, body: '{"error":"Unauthorized"}')

      expect { instance.channels }.to raise_error(Faraday::UnauthorizedError)
    end
  end
end
