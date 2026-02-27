# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Bundleup::Resources::Integration do
  let(:api_key) { 'test_api_key' }
  let(:instance) { described_class.new(api_key) }
  let(:base_url) { 'https://api.bundleup.io/v1' }

  describe '#list' do
    it 'makes a GET request to integrations endpoint' do
      stub = stub_request(:get, "#{base_url}/integrations")
             .with(
               headers: {
                 'Authorization' => "Bearer #{api_key}",
                 'Content-Type' => 'application/json'
               }
             )
             .to_return(
               status: 200,
               body: '{"data":[{"id":"int_1","name":"GitHub"}]}',
               headers: { 'Content-Type' => 'application/json' }
             )

      result = instance.list
      expect(result).to eq({ 'data' => [{ 'id' => 'int_1', 'name' => 'GitHub' }] })
      expect(stub).to have_been_requested
    end

    it 'supports query parameters' do
      stub = stub_request(:get, "#{base_url}/integrations?category=git")
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

      instance.list(params: { category: 'git' })
      expect(stub).to have_been_requested
    end

    it 'raises error on 401' do
      stub_request(:get, "#{base_url}/integrations")
        .to_return(status: 401, body: '{"error":"Unauthorized"}')

      expect { instance.list }.to raise_error(Faraday::UnauthorizedError)
    end
  end

  describe '#retrieve' do
    it 'makes a GET request to retrieve an integration' do
      stub = stub_request(:get, "#{base_url}/integrations/int_123")
             .with(
               headers: {
                 'Authorization' => "Bearer #{api_key}",
                 'Content-Type' => 'application/json'
               }
             )
             .to_return(
               status: 200,
               body: '{"id":"int_123","name":"GitHub","category":"git"}',
               headers: { 'Content-Type' => 'application/json' }
             )

      result = instance.retrieve('int_123')
      expect(result).to eq({ 'id' => 'int_123', 'name' => 'GitHub', 'category' => 'git' })
      expect(stub).to have_been_requested
    end

    it 'raises error when integration not found' do
      stub_request(:get, "#{base_url}/integrations/invalid_id")
        .to_return(status: 404, body: '{"error":"Not Found"}')

      expect { instance.retrieve('invalid_id') }.to raise_error(Faraday::ResourceNotFound)
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

  describe '#delete' do
    it 'is not implemented' do
      expect { instance.delete('conn_123') }.to raise_error(NoMethodError)
    end
  end
end
