# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BundleUp::Proxy do
  let(:api_key) { 'test_api_key' }
  let(:connection_id) { 'conn_123' }
  let(:instance) { described_class.new(api_key, connection_id) }
  let(:base_url) { 'https://proxy.bundleup.io' }

  describe '#initialize' do
    it 'creates a proxy with valid credentials' do
      expect(instance.api_key).to eq(api_key)
      expect(instance.connection_id).to eq(connection_id)
    end
  end

  describe '#get' do
    it 'makes a GET request to the specified path' do
      stub = stub_request(:get, "#{base_url}/some/path")
             .with(
               headers: {
                 'Authorization' => "Bearer #{api_key}",
                 'Content-Type' => 'application/json',
                 'BU-Connection-Id' => connection_id
               }
             )
             .to_return(
               status: 200,
               body: '{"data":"test"}',
               headers: { 'Content-Type' => 'application/json' }
             )

      instance.get('/some/path')
      expect(stub).to have_been_requested
    end

    it 'supports custom headers' do
      stub = stub_request(:get, "#{base_url}/some/path")
             .with(
               headers: {
                 'Authorization' => "Bearer #{api_key}",
                 'Content-Type' => 'application/json',
                 'BU-Connection-Id' => connection_id,
                 'X-Custom-Header' => 'value'
               }
             )
             .to_return(status: 200, body: '{}', headers: { 'Content-Type' => 'application/json' })

      instance.get('/some/path', headers: { 'X-Custom-Header' => 'value' })
      expect(stub).to have_been_requested
    end

    it 'raises error when path is nil' do
      expect { instance.get(nil) }.to raise_error(ArgumentError, 'Path is required for GET request')
    end

    it 'raises error on 401' do
      stub_request(:get, "#{base_url}/some/path")
        .to_return(status: 401, body: '{"error":"Unauthorized"}')

      expect { instance.get('/some/path') }.to raise_error(Faraday::UnauthorizedError)
    end
  end

  describe '#post' do
    it 'makes a POST request to the specified path' do
      body_data = { name: 'test', value: 123 }

      stub = stub_request(:post, "#{base_url}/some/path")
             .with(
               headers: {
                 'Authorization' => "Bearer #{api_key}",
                 'Content-Type' => 'application/json',
                 'BU-Connection-Id' => connection_id
               },
               body: body_data.to_json
             )
             .to_return(
               status: 201,
               body: '{"id":"item_123"}',
               headers: { 'Content-Type' => 'application/json' }
             )

      instance.post('/some/path', body: body_data)
      expect(stub).to have_been_requested
    end

    it 'supports custom headers' do
      stub = stub_request(:post, "#{base_url}/some/path")
             .with(
               headers: {
                 'Authorization' => "Bearer #{api_key}",
                 'Content-Type' => 'application/json',
                 'BU-Connection-Id' => connection_id,
                 'X-Custom-Header' => 'value'
               }
             )
             .to_return(status: 201, body: '{}', headers: { 'Content-Type' => 'application/json' })

      instance.post('/some/path', body: {}, headers: { 'X-Custom-Header' => 'value' })
      expect(stub).to have_been_requested
    end

    it 'raises error when path is nil' do
      expect { instance.post(nil, body: {}) }.to raise_error(ArgumentError, 'Path is required for POST request')
    end
  end

  describe '#put' do
    it 'makes a PUT request to the specified path' do
      body_data = { name: 'updated' }

      stub = stub_request(:put, "#{base_url}/some/path")
             .with(
               headers: {
                 'Authorization' => "Bearer #{api_key}",
                 'Content-Type' => 'application/json',
                 'BU-Connection-Id' => connection_id
               },
               body: body_data.to_json
             )
             .to_return(
               status: 200,
               body: '{"id":"item_123","name":"updated"}',
               headers: { 'Content-Type' => 'application/json' }
             )

      instance.put('/some/path', body: body_data)
      expect(stub).to have_been_requested
    end

    it 'raises error when path is nil' do
      expect { instance.put(nil, body: {}) }.to raise_error(ArgumentError, 'Path is required for PUT request')
    end
  end

  describe '#patch' do
    it 'makes a PATCH request to the specified path' do
      body_data = { status: 'active' }

      stub = stub_request(:patch, "#{base_url}/some/path")
             .with(
               headers: {
                 'Authorization' => "Bearer #{api_key}",
                 'Content-Type' => 'application/json',
                 'BU-Connection-Id' => connection_id
               },
               body: body_data.to_json
             )
             .to_return(
               status: 200,
               body: '{"status":"active"}',
               headers: { 'Content-Type' => 'application/json' }
             )

      instance.patch('/some/path', body: body_data)
      expect(stub).to have_been_requested
    end

    it 'raises error when path is nil' do
      expect { instance.patch(nil, body: {}) }.to raise_error(ArgumentError, 'Path is required for PATCH request')
    end
  end

  describe '#delete' do
    it 'makes a DELETE request to the specified path' do
      stub = stub_request(:delete, "#{base_url}/some/path")
             .with(
               headers: {
                 'Authorization' => "Bearer #{api_key}",
                 'Content-Type' => 'application/json',
                 'BU-Connection-Id' => connection_id
               }
             )
             .to_return(
               status: 204,
               body: '',
               headers: {}
             )

      instance.delete('/some/path')
      expect(stub).to have_been_requested
    end

    it 'supports custom headers' do
      stub = stub_request(:delete, "#{base_url}/some/path")
             .with(
               headers: {
                 'Authorization' => "Bearer #{api_key}",
                 'Content-Type' => 'application/json',
                 'BU-Connection-Id' => connection_id,
                 'X-Custom-Header' => 'value'
               }
             )
             .to_return(status: 204, body: '', headers: {})

      instance.delete('/some/path', headers: { 'X-Custom-Header' => 'value' })
      expect(stub).to have_been_requested
    end

    it 'raises error when path is nil' do
      expect { instance.delete(nil) }.to raise_error(ArgumentError, 'Path is required for DELETE request')
    end
  end
end
