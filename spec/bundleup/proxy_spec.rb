# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Bundleup::Proxy do
  let(:instance) { described_class.new('test_api_key', 'conn_123') }

  describe '#initialize' do
    it 'stores the API key and connection ID' do
      expect(instance.api_key).to eq('test_api_key')
      expect(instance.connection_id).to eq('conn_123')
    end
  end

  describe '#get' do
    it 'makes a GET request with proper headers' do
      stub = stub_request(:get, 'https://proxy.bundleup.io/api/users')
             .with(headers: {
                     'Authorization' => 'Bearer test_api_key',
                     'BU-Connection-Id' => 'conn_123'
                   })
             .to_return(status: 200, body: '{"users":[]}', headers: { 'Content-Type' => 'application/json' })

      instance.get('/api/users')

      expect(stub).to have_been_requested
    end
  end

  describe '#post' do
    it 'makes a POST request with body' do
      stub = stub_request(:post, 'https://proxy.bundleup.io/api/users')
             .with(
               headers: {
                 'Authorization' => 'Bearer test_api_key',
                 'BU-Connection-Id' => 'conn_123',
                 'Content-Type' => 'application/json'
               },
               body: '{"name":"Test"}'
             )
             .to_return(status: 201, body: '{"id":"123"}', headers: { 'Content-Type' => 'application/json' })

      instance.post('/api/users', name: 'Test')

      expect(stub).to have_been_requested
    end
  end

  describe '#put' do
    it 'makes a PUT request' do
      stub = stub_request(:put, 'https://proxy.bundleup.io/api/users/123')
             .with(
               headers: {
                 'Authorization' => 'Bearer test_api_key',
                 'BU-Connection-Id' => 'conn_123',
                 'Content-Type' => 'application/json'
               },
               body: '{"name":"Updated"}'
             )
             .to_return(status: 200, body: '{"id":"123"}', headers: { 'Content-Type' => 'application/json' })

      instance.put('/api/users/123', name: 'Updated')

      expect(stub).to have_been_requested
    end
  end

  describe '#patch' do
    it 'makes a PATCH request' do
      stub = stub_request(:patch, 'https://proxy.bundleup.io/api/users/123')
             .with(
               headers: {
                 'Authorization' => 'Bearer test_api_key',
                 'BU-Connection-Id' => 'conn_123',
                 'Content-Type' => 'application/json'
               },
               body: '{"email":"test@example.com"}'
             )
             .to_return(status: 200, body: '{"id":"123"}', headers: { 'Content-Type' => 'application/json' })

      instance.patch('/api/users/123', email: 'test@example.com')

      expect(stub).to have_been_requested
    end
  end

  describe '#delete' do
    it 'makes a DELETE request' do
      stub = stub_request(:delete, 'https://proxy.bundleup.io/api/users/123')
             .with(headers: {
                     'Authorization' => 'Bearer test_api_key',
                     'BU-Connection-Id' => 'conn_123'
                   })
             .to_return(status: 204, body: '', headers: {})

      instance.delete('/api/users/123')

      expect(stub).to have_been_requested
    end
  end
end
