# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BundleUp::Unify::Calendar do
  let(:api_key) { 'test_api_key' }
  let(:connection_id) { 'conn_123' }
  let(:instance) { described_class.new(api_key, connection_id) }
  let(:base_url) { 'https://unify.bundleup.io/v1' }
  let(:window) { { starts_after: '2026-09-01T00:00:00Z', starts_before: '2026-09-08T00:00:00Z' } }

  describe '#events' do
    it 'makes a GET request to events endpoint' do
      stub = stub_request(:get, "#{base_url}/calendar/events")
             .with(
               query: window,
               headers: {
                 'Authorization' => "Bearer #{api_key}",
                 'Content-Type' => 'application/json',
                 'BU-Connection-Id' => connection_id
               }
             )
             .to_return(
               status: 200,
               body: '{"data":[{"id":"evt_1","title":"Standup","status":"confirmed"}]}',
               headers: { 'Content-Type' => 'application/json' }
             )

      result = instance.events(window)
      expect(result).to eq(
        { 'data' => [{ 'id' => 'evt_1', 'title' => 'Standup', 'status' => 'confirmed' }] }
      )
      expect(stub).to have_been_requested
    end

    it 'raises without both bounds' do
      [{}, { starts_after: window[:starts_after] }, { starts_before: window[:starts_before] }].each do |params|
        expect { instance.events(params) }
          .to raise_error(ArgumentError, 'starts_after and starts_before are required to fetch events.')
      end
    end

    it 'raises error on 401' do
      stub_request(:get, "#{base_url}/calendar/events")
        .with(query: window)
        .to_return(status: 401, body: '{"error":"Unauthorized"}')

      expect { instance.events(window) }.to raise_error(Faraday::UnauthorizedError)
    end
  end
end
