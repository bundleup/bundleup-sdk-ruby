# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BundleUp::Unify::Ticketing do
  let(:api_key) { 'test_api_key' }
  let(:connection_id) { 'conn_123' }
  let(:instance) { described_class.new(api_key, connection_id) }
  let(:base_url) { 'https://unify.bundleup.io/v1' }

  describe '#tickets' do
    it 'makes a GET request to tickets endpoint' do
      stub = stub_request(:get, "#{base_url}/ticketing/tickets")
             .with(
               headers: {
                 'Authorization' => "Bearer #{api_key}",
                 'Content-Type' => 'application/json',
                 'BU-Connection-Id' => connection_id
               }
             )
             .to_return(
               status: 200,
               body: '{"data":[{"id":"ticket_1","title":"Bug fix"}]}',
               headers: { 'Content-Type' => 'application/json' }
             )

      result = instance.tickets
      expect(result).to eq({ 'data' => [{ 'id' => 'ticket_1', 'title' => 'Bug fix' }] })
      expect(stub).to have_been_requested
    end

    it 'supports additional query parameters' do
      stub = stub_request(:get, "#{base_url}/ticketing/tickets?status=open&assignee=john")
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

      instance.tickets(status: 'open', assignee: 'john')
      expect(stub).to have_been_requested
    end

    it 'raises error on 401' do
      stub_request(:get, "#{base_url}/ticketing/tickets")
        .to_return(status: 401, body: '{"error":"Unauthorized"}')

      expect { instance.tickets }.to raise_error(Faraday::UnauthorizedError)
    end

    it 'raises error on 429 rate limit' do
      stub_request(:get, "#{base_url}/ticketing/tickets")
        .to_return(status: 429, body: '{"error":"Rate limit exceeded"}')

      expect { instance.tickets }.to raise_error(Faraday::TooManyRequestsError)
    end
  end
end
