# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BundleUp::Resources::Connection do
  let(:api_key) { 'test_api_key' }
  let(:instance) { described_class.new(api_key) }
  let(:base_url) { 'https://api.bundleup.io/v1' }

  describe '#list' do
    it 'makes a GET request to connections endpoint' do
      stub = stub_request(:get, "#{base_url}/connections")
             .with(
               headers: {
                 'Authorization' => "Bearer #{api_key}",
                 'Content-Type' => 'application/json'
               }
             )
             .to_return(
               status: 200,
               body: '{"data":[{"id":"conn_1","name":"Test Connection"}]}',
               headers: { 'Content-Type' => 'application/json' }
             )

      result = instance.list
      expect(result).to eq({ 'data' => [{ 'id' => 'conn_1', 'name' => 'Test Connection' }] })
      expect(stub).to have_been_requested
    end

    it 'supports query parameters' do
      stub = stub_request(:get, "#{base_url}/connections?limit=10&offset=0")
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

      instance.list(params: { limit: 10, offset: 0 })
      expect(stub).to have_been_requested
    end

    it 'raises error on 401' do
      stub_request(:get, "#{base_url}/connections")
        .to_return(status: 401, body: '{"error":"Unauthorized"}')

      expect { instance.list }.to raise_error(Faraday::UnauthorizedError)
    end

    it 'raises error on 404' do
      stub_request(:get, "#{base_url}/connections")
        .to_return(status: 404, body: '{"error":"Not Found"}')

      expect { instance.list }.to raise_error(Faraday::ResourceNotFound)
    end
  end

  describe '#retrieve' do
    it 'makes a GET request to retrieve a connection' do
      stub = stub_request(:get, "#{base_url}/connections/conn_123")
             .with(
               headers: {
                 'Authorization' => "Bearer #{api_key}",
                 'Content-Type' => 'application/json'
               }
             )
             .to_return(
               status: 200,
               body: '{"id":"conn_123","name":"My Connection"}',
               headers: { 'Content-Type' => 'application/json' }
             )

      result = instance.retrieve('conn_123')
      expect(result).to eq({ 'id' => 'conn_123', 'name' => 'My Connection' })
      expect(stub).to have_been_requested
    end

    it 'raises error when connection not found' do
      stub_request(:get, "#{base_url}/connections/invalid_id")
        .to_return(status: 404, body: '{"error":"Not Found"}')

      expect { instance.retrieve('invalid_id') }.to raise_error(Faraday::ResourceNotFound)
    end
  end

  describe '#delete' do
    it 'makes a DELETE request to remove a connection' do
      stub = stub_request(:delete, "#{base_url}/connections/conn_123")
             .with(
               headers: {
                 'Authorization' => "Bearer #{api_key}",
                 'Content-Type' => 'application/json'
               }
             )
             .to_return(
               status: 200,
               body: '{"message":"Connection deleted"}',
               headers: { 'Content-Type' => 'application/json' }
             )

      result = instance.delete('conn_123')
      expect(result).to be_nil
      expect(stub).to have_been_requested
    end

    it 'raises error when connection not found' do
      stub_request(:delete, "#{base_url}/connections/invalid_id")
        .to_return(status: 404, body: '{"error":"Not Found"}')

      expect { instance.delete('invalid_id') }.to raise_error(Faraday::ResourceNotFound)
    end
  end

  describe '#update' do
    it 'is not implemented' do
      expect { instance.update('conn_123', name: 'New Name') }.to raise_error(NoMethodError)
    end
  end

  describe '#create' do
    it 'is not implemented' do
      expect { instance.create(name: 'New Connection') }.to raise_error(NoMethodError)
    end
  end
end
