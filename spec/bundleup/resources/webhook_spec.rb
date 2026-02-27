# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Bundleup::Resources::Webhook do
  let(:api_key) { 'test_api_key' }
  let(:instance) { described_class.new(api_key) }
  let(:base_url) { 'https://api.bundleup.io/v1' }

  describe '#list' do
    it 'makes a GET request to webhooks endpoint' do
      stub = stub_request(:get, "#{base_url}/webhooks")
             .with(
               headers: {
                 'Authorization' => "Bearer #{api_key}",
                 'Content-Type' => 'application/json'
               }
             )
             .to_return(
               status: 200,
               body: '{"data":[{"id":"wh_1","url":"https://example.com/webhook"}]}',
               headers: { 'Content-Type' => 'application/json' }
             )

      result = instance.list
      expect(result).to eq({ 'data' => [{ 'id' => 'wh_1', 'url' => 'https://example.com/webhook' }] })
      expect(stub).to have_been_requested
    end

    it 'supports query parameters' do
      stub = stub_request(:get, "#{base_url}/webhooks?active=true")
             .with(
               headers: {
                 'Authorization' => "Bearer #{api_key}",
                 'Content-Type' => 'application/json'
               }
             )
             .to_return(
               status: 200,
               body: '{"data":[]}',
               headers: { 'Content-Type' => 'application/json' }
             )

      instance.list(params: { active: true })
      expect(stub).to have_been_requested
    end
  end

  describe '#create' do
    it 'makes a POST request to create a webhook' do
      webhook_data = { url: 'https://example.com/webhook', events: ['connection.created'] }

      stub = stub_request(:post, "#{base_url}/webhooks")
             .with(
               headers: {
                 'Authorization' => "Bearer #{api_key}",
                 'Content-Type' => 'application/json'
               },
               body: webhook_data.to_json
             )
             .to_return(
               status: 201,
               body: '{"id":"wh_123","url":"https://example.com/webhook"}',
               headers: { 'Content-Type' => 'application/json' }
             )

      result = instance.create(body: webhook_data)
      expect(result).to eq({ 'id' => 'wh_123', 'url' => 'https://example.com/webhook' })
      expect(stub).to have_been_requested
    end

    it 'raises error on validation failure' do
      stub_request(:post, "#{base_url}/webhooks")
        .to_return(status: 422, body: '{"error":"Invalid URL"}')

      expect { instance.create(body: { url: 'invalid' }) }.to raise_error(Faraday::UnprocessableEntityError)
    end
  end

  describe '#retrieve' do
    it 'makes a GET request to retrieve a webhook' do
      stub = stub_request(:get, "#{base_url}/webhooks/wh_123")
             .with(
               headers: {
                 'Authorization' => "Bearer #{api_key}",
                 'Content-Type' => 'application/json'
               }
             )
             .to_return(
               status: 200,
               body: '{"id":"wh_123","url":"https://example.com/webhook"}',
               headers: { 'Content-Type' => 'application/json' }
             )

      result = instance.retrieve('wh_123')
      expect(result).to eq({ 'id' => 'wh_123', 'url' => 'https://example.com/webhook' })
      expect(stub).to have_been_requested
    end

    it 'raises error when webhook not found' do
      stub_request(:get, "#{base_url}/webhooks/invalid_id")
        .to_return(status: 404, body: '{"error":"Not Found"}')

      expect { instance.retrieve('invalid_id') }.to raise_error(Faraday::ResourceNotFound)
    end
  end

  describe '#update' do
    it 'makes a PUT request to update a webhook' do
      webhook_data = { active: false }

      stub = stub_request(:put, "#{base_url}/webhooks/wh_123")
             .with(
               headers: {
                 'Authorization' => "Bearer #{api_key}",
                 'Content-Type' => 'application/json'
               },
               body: webhook_data.to_json
             )
             .to_return(
               status: 200,
               body: '{"id":"wh_123","active":false}',
               headers: { 'Content-Type' => 'application/json' }
             )

      result = instance.update('wh_123', body: webhook_data)
      expect(result).to eq({ 'id' => 'wh_123', 'active' => false })
      expect(stub).to have_been_requested
    end

    it 'raises error when webhook not found' do
      stub_request(:put, "#{base_url}/webhooks/invalid_id")
        .to_return(status: 404, body: '{"error":"Not Found"}')

      expect { instance.update('invalid_id', body: {}) }.to raise_error(Faraday::ResourceNotFound)
    end
  end

  describe '#delete' do
    it 'makes a DELETE request to remove a webhook' do
      stub = stub_request(:delete, "#{base_url}/webhooks/wh_123")
             .with(
               headers: {
                 'Authorization' => "Bearer #{api_key}",
                 'Content-Type' => 'application/json'
               }
             )
             .to_return(
               status: 200,
               body: '{"message":"Webhook deleted"}',
               headers: { 'Content-Type' => 'application/json' }
             )

      result = instance.delete('wh_123')
      expect(result).to be_nil
      expect(stub).to have_been_requested
    end

    it 'raises error when webhook not found' do
      stub_request(:delete, "#{base_url}/webhooks/invalid_id")
        .to_return(status: 404, body: '{"error":"Not Found"}')

      expect { instance.delete('invalid_id') }.to raise_error(Faraday::ResourceNotFound)
    end
  end
end
