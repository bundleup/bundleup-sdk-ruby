# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BundleUp::MCP do
  subject(:mcp) { described_class.new(api_key, connection_id) }

  let(:api_key) { 'test-api-key' }
  let(:connection_id) { 'conn_123' }
  let(:url) { 'https://mcp.bundleup.io' }

  def json_response(payload)
    { body: payload.to_json, headers: { 'Content-Type' => 'application/json' } }
  end

  describe '#transport' do
    it 'returns the server URL' do
      expect(mcp.transport[:url]).to eq(url)
    end

    it 'returns the auth headers' do
      expect(mcp.transport[:headers]).to include(
        'Authorization' => "Bearer #{api_key}",
        'BU-Connection-Id' => connection_id,
        'Accept' => 'application/json, text/event-stream'
      )
    end
  end

  describe '#hosted' do
    it 'joins the API key and connection ID into one token' do
      expect(mcp.hosted).to eq(url: url, token: "#{api_key}.#{connection_id}")
    end
  end

  describe '#post' do
    it 'sends the body untouched' do
      request = stub_request(:post, url).with(body: { jsonrpc: '2.0', method: 'tools/list' }.to_json)
                                        .to_return(json_response({}))

      mcp.post({ jsonrpc: '2.0', method: 'tools/list' })

      expect(request).to have_been_requested
    end

    it 'accepts an already serialized body' do
      request = stub_request(:post, url).with(body: '{"jsonrpc":"2.0"}').to_return(json_response({}))

      mcp.post('{"jsonrpc":"2.0"}')

      expect(request).to have_been_requested
    end

    it 'merges extra headers over the defaults' do
      request = stub_request(:post, url)
                .with(headers: { 'Mcp-Session-Id' => 'sess_abc', 'BU-Connection-Id' => connection_id })
                .to_return(json_response({}))

      mcp.post({}, headers: { 'Mcp-Session-Id' => 'sess_abc' })

      expect(request).to have_been_requested
    end

    it 'does not raise on an error response' do
      stub_request(:post, url).to_return(status: 429, body: '{"code":"rate_limit"}')

      expect(mcp.post({}).status).to eq(429)
    end
  end

  describe '#delete' do
    it 'ends a session' do
      request = stub_request(:delete, url).with(headers: { 'Mcp-Session-Id' => 'sess_abc' })

      mcp.delete(headers: { 'Mcp-Session-Id' => 'sess_abc' })

      expect(request).to have_been_requested
    end
  end
end
