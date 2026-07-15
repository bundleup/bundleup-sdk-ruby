# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BundleUp::Unify::CRM do
  let(:api_key) { 'test_api_key' }
  let(:connection_id) { 'conn_123' }
  let(:instance) { described_class.new(api_key, connection_id) }
  let(:base_url) { 'https://unify.bundleup.io/v1' }

  describe '#companies' do
    it 'makes a GET request to companies endpoint' do
      stub = stub_request(:get, "#{base_url}/crm/companies")
             .with(
               headers: {
                 'Authorization' => "Bearer #{api_key}",
                 'Content-Type' => 'application/json',
                 'BU-Connection-Id' => connection_id
               }
             )
             .to_return(
               status: 200,
               body: '{"data":[{"id":"co_1","name":"Acme Inc.","website":"https://acme.example.com"}]}',
               headers: { 'Content-Type' => 'application/json' }
             )

      result = instance.companies
      expect(result).to eq(
        { 'data' => [{ 'id' => 'co_1', 'name' => 'Acme Inc.', 'website' => 'https://acme.example.com' }] }
      )
      expect(stub).to have_been_requested
    end

    it 'raises error on 401' do
      stub_request(:get, "#{base_url}/crm/companies")
        .to_return(status: 401, body: '{"error":"Unauthorized"}')

      expect { instance.companies }.to raise_error(Faraday::UnauthorizedError)
    end
  end

  describe '#contacts' do
    it 'makes a GET request to contacts endpoint' do
      stub = stub_request(:get, "#{base_url}/crm/contacts")
             .with(
               headers: {
                 'Authorization' => "Bearer #{api_key}",
                 'Content-Type' => 'application/json',
                 'BU-Connection-Id' => connection_id
               }
             )
             .to_return(
               status: 200,
               body: '{"data":[{"id":"ct_1","name":"Jane Doe","email":"jane@acme.example.com"}]}',
               headers: { 'Content-Type' => 'application/json' }
             )

      result = instance.contacts
      expect(result).to eq(
        { 'data' => [{ 'id' => 'ct_1', 'name' => 'Jane Doe', 'email' => 'jane@acme.example.com' }] }
      )
      expect(stub).to have_been_requested
    end
  end
end
