# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BundleUp::Unify::MCP do
  subject(:unified) { described_class.new(api_key, connection_id) }

  let(:api_key) { 'test-api-key' }
  let(:connection_id) { 'conn_123' }
  let(:url) { 'https://unify.bundleup.io/v1/mcp' }
  let(:tool) { { 'name' => 'send_message' } }

  def rpc(id, result)
    { 'jsonrpc' => '2.0', 'id' => id, 'result' => result }
  end

  # Handshake plus whatever follows, on one stub — a second stub_request for
  # the same verb and URL would shadow this one.
  def stub_session(*responses)
    stub_request(:post, url).to_return(
      { body: rpc(1, { 'protocolVersion' => '2025-06-18' }).to_json,
        headers: { 'Content-Type' => 'application/json' } },
      { body: '', status: 202 },
      *responses
    )
  end

  describe '#hosted' do
    it 'targets the Unified server with a composite token' do
      expect(unified.hosted).to eq(url: url, token: "#{api_key}.#{connection_id}")
    end
  end

  describe '#tools' do
    it 'lists tools against the Unified server' do
      stub_session({ body: rpc(2, { 'tools' => [tool] }).to_json,
                     headers: { 'Content-Type' => 'application/json' } })

      expect(unified.tools).to eq([tool])
    end
  end

  describe '#tool' do
    it 'requires a tool name' do
      expect { unified.tool('') }.to raise_error(ArgumentError, /Tool name is required/)
    end

    it 'reuses one session across calls' do
      stub_session(
        { body: rpc(2, { 'tools' => [] }).to_json, headers: { 'Content-Type' => 'application/json' } },
        { body: rpc(3, { 'content' => [] }).to_json, headers: { 'Content-Type' => 'application/json' } }
      )

      unified.tools
      unified.tool('send_message')

      expect(a_request(:post, url).with(body: /"method":"initialize"/)).to have_been_made.once
    end
  end
end
