# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BundleUp::Unify::Helpdesk do
  let(:api_key) { 'test_api_key' }
  let(:connection_id) { 'conn_123' }
  let(:instance) { described_class.new(api_key, connection_id) }
  let(:base_url) { 'https://unify.bundleup.io/v1' }

  describe '#tickets' do
    it 'makes a GET request to tickets endpoint' do
      stub = stub_request(:get, "#{base_url}/helpdesk/tickets")
             .with(
               headers: {
                 'Authorization' => "Bearer #{api_key}",
                 'Content-Type' => 'application/json',
                 'BU-Connection-Id' => connection_id
               }
             )
             .to_return(
               status: 200,
               body: '{"data":[{"id":"4182","title":"Refund"}]}',
               headers: { 'Content-Type' => 'application/json' }
             )

      result = instance.tickets
      expect(result).to eq({ 'data' => [{ 'id' => '4182', 'title' => 'Refund' }] })
      expect(stub).to have_been_requested
    end

    it 'supports paging parameters' do
      stub = stub_request(:get, "#{base_url}/helpdesk/tickets?after=cursor_1&limit=5")
             .to_return(status: 200, body: '{"data":[]}', headers: { 'Content-Type' => 'application/json' })

      instance.tickets(limit: 5, after: 'cursor_1')
      expect(stub).to have_been_requested
    end

    it 'raises error on 401' do
      stub_request(:get, "#{base_url}/helpdesk/tickets")
        .to_return(status: 401, body: '{"error":"Unauthorized"}')

      expect { instance.tickets }.to raise_error(Faraday::UnauthorizedError)
    end
  end

  describe '#ticket' do
    it 'makes a GET request to the single ticket endpoint' do
      stub = stub_request(:get, "#{base_url}/helpdesk/tickets/4182")
             .to_return(
               status: 200,
               body: '{"data":{"id":"4182","title":"Refund"}}',
               headers: { 'Content-Type' => 'application/json' }
             )

      result = instance.ticket('4182')
      expect(result).to eq({ 'data' => { 'id' => '4182', 'title' => 'Refund' } })
      expect(stub).to have_been_requested
    end

    it 'encodes the ticket id' do
      stub = stub_request(:get, "#{base_url}/helpdesk/tickets/a%2Fb")
             .to_return(status: 200, body: '{"data":{}}', headers: { 'Content-Type' => 'application/json' })

      instance.ticket('a/b')
      expect(stub).to have_been_requested
    end

    it 'raises without an id' do
      expect { instance.ticket(nil) }
        .to raise_error(ArgumentError, 'ticket_id is required to fetch a ticket.')
    end

    it 'raises error on 404' do
      stub_request(:get, "#{base_url}/helpdesk/tickets/4182")
        .to_return(status: 404, body: '{"error":"Not Found"}')

      expect { instance.ticket('4182') }.to raise_error(Faraday::ResourceNotFound)
    end
  end
end
