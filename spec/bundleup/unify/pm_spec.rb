# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BundleUp::Unify::PM do
  let(:api_key) { 'test_api_key' }
  let(:connection_id) { 'conn_123' }
  let(:instance) { described_class.new(api_key, connection_id) }
  let(:base_url) { 'https://unify.bundleup.io/v1' }

  describe '#issues' do
    it 'makes a GET request to issues endpoint' do
      stub = stub_request(:get, "#{base_url}/pm/issues")
             .with(
               headers: {
                 'Authorization' => "Bearer #{api_key}",
                 'Content-Type' => 'application/json',
                 'BU-Connection-Id' => connection_id
               }
             )
             .to_return(
               status: 200,
               body: '{"data":[{"id":"issue_1","title":"Bug fix"}]}',
               headers: { 'Content-Type' => 'application/json' }
             )

      result = instance.issues
      expect(result).to eq({ 'data' => [{ 'id' => 'issue_1', 'title' => 'Bug fix' }] })
      expect(stub).to have_been_requested
    end

    it 'supports additional query parameters' do
      stub = stub_request(:get, "#{base_url}/pm/issues?status=open&assignee=john")
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

      instance.issues(status: 'open', assignee: 'john')
      expect(stub).to have_been_requested
    end

    it 'raises error on 401' do
      stub_request(:get, "#{base_url}/pm/issues")
        .to_return(status: 401, body: '{"error":"Unauthorized"}')

      expect { instance.issues }.to raise_error(Faraday::UnauthorizedError)
    end

    it 'raises error on 429 rate limit' do
      stub_request(:get, "#{base_url}/pm/issues")
        .to_return(status: 429, body: '{"error":"Rate limit exceeded"}')

      expect { instance.issues }.to raise_error(Faraday::TooManyRequestsError)
    end
  end
end
