# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Bundleup::Base do
  let(:test_class) do
    Class.new(described_class) do
      private

      def resource_name
        'test_resources'
      end
    end
  end

  let(:instance) { test_class.new('test_api_key') }

  describe '#initialize' do
    it 'stores the API key' do
      expect(instance.api_key).to eq('test_api_key')
    end
  end

  describe '#list' do
    it 'makes a GET request to the resource path' do
      stub = stub_request(:get, 'https://api.bundleup.io/v1/test_resources')
        .with(headers: { 'Authorization' => 'Bearer test_api_key' })
        .to_return(status: 200, body: '{"data": []}', headers: { 'Content-Type' => 'application/json' })

      instance.list

      expect(stub).to have_been_requested
    end
  end

  describe '#create' do
    it 'makes a POST request with data' do
      stub = stub_request(:post, 'https://api.bundleup.io/v1/test_resources')
        .with(
          headers: { 'Authorization' => 'Bearer test_api_key', 'Content-Type' => 'application/json' },
          body: '{"name":"Test"}'
        )
        .to_return(status: 201, body: '{"id":"123"}', headers: { 'Content-Type' => 'application/json' })

      instance.create(name: 'Test')

      expect(stub).to have_been_requested
    end
  end

  describe '#retrieve' do
    it 'makes a GET request with the resource ID' do
      stub = stub_request(:get, 'https://api.bundleup.io/v1/test_resources/123')
        .with(headers: { 'Authorization' => 'Bearer test_api_key' })
        .to_return(status: 200, body: '{"id":"123"}', headers: { 'Content-Type' => 'application/json' })

      instance.retrieve('123')

      expect(stub).to have_been_requested
    end
  end

  describe '#update' do
    it 'makes a PATCH request with data' do
      stub = stub_request(:patch, 'https://api.bundleup.io/v1/test_resources/123')
        .with(
          headers: { 'Authorization' => 'Bearer test_api_key', 'Content-Type' => 'application/json' },
          body: '{"name":"Updated"}'
        )
        .to_return(status: 200, body: '{"id":"123"}', headers: { 'Content-Type' => 'application/json' })

      instance.update('123', name: 'Updated')

      expect(stub).to have_been_requested
    end
  end

  describe '#delete' do
    it 'makes a DELETE request' do
      stub = stub_request(:delete, 'https://api.bundleup.io/v1/test_resources/123')
        .with(headers: { 'Authorization' => 'Bearer test_api_key' })
        .to_return(status: 204, body: '', headers: {})

      instance.delete('123')

      expect(stub).to have_been_requested
    end
  end

  describe 'error handling' do
    it 'raises AuthenticationError on 401' do
      stub_request(:get, 'https://api.bundleup.io/v1/test_resources')
        .to_return(status: 401, body: '{"error":"Unauthorized"}')

      expect { instance.list }.to raise_error(Bundleup::AuthenticationError, 'Invalid API key')
    end

    it 'raises InvalidRequestError on 400' do
      stub_request(:get, 'https://api.bundleup.io/v1/test_resources')
        .to_return(status: 400, body: '{"error":"Bad Request"}')

      expect { instance.list }.to raise_error(Bundleup::InvalidRequestError, 'Bad Request')
    end

    it 'raises APIError on 500' do
      stub_request(:get, 'https://api.bundleup.io/v1/test_resources')
        .to_return(status: 500, body: '')

      expect { instance.list }.to raise_error(Bundleup::APIError, 'Server error occurred')
    end
  end
end
