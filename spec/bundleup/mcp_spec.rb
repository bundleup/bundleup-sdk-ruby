# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BundleUp::MCP do
  subject(:mcp) { described_class.new(api_key, connection_id) }

  let(:api_key) { 'test-api-key' }
  let(:connection_id) { 'conn_123' }
  let(:url) { 'https://mcp.bundleup.io' }
  let(:tool) { { 'name' => 'create_issue', 'description' => 'Create an issue' } }

  def rpc(id, result: nil, error: nil)
    body = { 'jsonrpc' => '2.0', 'id' => id }
    error ? body.merge('error' => error) : body.merge('result' => result || {})
  end

  # The handshake (initialize, then notifications/initialized) followed by
  # whatever the test expects next, all on one stub.
  def stub_session(*responses)
    opts = responses.last.is_a?(Hash) && !responses.last.key?(:body) ? responses.pop : {}
    target = opts.fetch(:target, 'https://mcp.bundleup.io')
    session_id = opts.fetch(:session_id, 'sess_123')
    stub_request(:post, target)
      .to_return(
        { body: rpc(1, result: { 'protocolVersion' => '2025-06-18' }).to_json,
          headers: { 'Content-Type' => 'application/json', 'Mcp-Session-Id' => session_id } },
        { body: '', status: 202 },
        *responses
      )
  end

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

  describe '#connect' do
    it 'returns a managed client' do
      expect(mcp.connect).to be_a(BundleUp::MCPClient)
    end

    it 'returns a new client each call' do
      expect(mcp.connect).not_to be(mcp.connect)
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

  describe 'handshake' do
    it 'runs before the first call' do
      stub_session(json_response(rpc(2, result: { 'tools' => [tool] })))

      mcp.connect.list_tools

      expect(a_request(:post, url).with(body: /"method":"initialize"/)).to have_been_made.once
    end

    it 'runs only once across calls' do
      stub_session(
        json_response(rpc(2, result: { 'tools' => [] })),
        json_response(rpc(3, result: { 'resources' => [] }))
      )

      client = mcp.connect
      client.list_tools
      client.list_resources

      expect(a_request(:post, url).with(body: /"method":"initialize"/)).to have_been_made.once
    end

    it 'replays the session ID' do
      stub_session(json_response(rpc(2, result: { 'tools' => [] })), session_id: 'sess_abc')

      mcp.connect.list_tools

      # Everything after initialize carries it.
      expect(
        a_request(:post, url).with(body: %r{"method":"tools/list"},
                                   headers: { 'Mcp-Session-Id' => 'sess_abc' })
      ).to have_been_made
    end
  end

  describe '#list_tools' do
    it 'returns the provider tool list' do
      stub_session(json_response(rpc(2, result: { 'tools' => [tool] })))

      expect(mcp.connect.list_tools).to eq([tool])
    end

    it 'follows nextCursor pagination' do
      stub_session(
        json_response(rpc(2, result: { 'tools' => [tool], 'nextCursor' => 'page2' })),
        json_response(rpc(3, result: { 'tools' => [tool.merge('name' => 'list_issues')] }))
      )

      expect(mcp.connect.list_tools.length).to eq(2)
    end

    it 'parses a result delivered as an event stream' do
      stream = "event: message\r\ndata: {\"jsonrpc\":\"2.0\",\"method\":\"notifications/message\"}\r\n\r\n" \
               "event: message\r\ndata: #{rpc(2, result: { 'tools' => [tool] }).to_json}\r\n\r\n"
      stub_session({ body: stream, headers: { 'Content-Type' => 'text/event-stream' } })

      expect(mcp.connect.list_tools).to eq([tool])
    end
  end

  describe '#call_tool' do
    it 'sends the name and arguments' do
      stub_session(json_response(rpc(2, result: { 'content' => [] })))

      mcp.connect.call_tool('create_issue', { title: 'Login broken' })

      expect(a_request(:post, url).with(body: /"name":"create_issue"/)).to have_been_made
    end

    it 'requires a tool name' do
      expect { mcp.connect.call_tool('') }.to raise_error(ArgumentError, /Tool name is required/)
    end

    it 'surfaces a JSON-RPC error' do
      failure = rpc(2, error: { 'code' => -32_602, 'message' => 'Unknown tool' })
      stub_session(json_response(failure))

      expect { mcp.connect.call_tool('nope') }.to raise_error(/Unknown tool/)
    end
  end

  describe 'resources and prompts' do
    it 'lists resources' do
      resource = { 'uri' => 'file:///readme.md', 'name' => 'readme' }
      stub_session(json_response(rpc(2, result: { 'resources' => [resource] })))

      expect(mcp.connect.list_resources).to eq([resource])
    end

    it 'reads a resource by URI' do
      stub_session(json_response(rpc(2, result: { 'contents' => [] })))

      mcp.connect.read_resource('file:///readme.md')

      expect(a_request(:post, url).with(body: %r{"uri":"file:///readme.md"})).to have_been_made
    end

    it 'requires a resource URI' do
      expect { mcp.connect.read_resource('') }.to raise_error(ArgumentError, /Resource URI is required/)
    end

    it 'lists prompts' do
      stub_session(json_response(rpc(2, result: { 'prompts' => [{ 'name' => 'x' }] })))

      expect(mcp.connect.list_prompts).to eq([{ 'name' => 'x' }])
    end

    it 'requires a prompt name' do
      expect { mcp.connect.get_prompt('') }.to raise_error(ArgumentError, /Prompt name is required/)
    end

    it 'sends an arbitrary method' do
      stub_session(json_response(rpc(2, result: { 'ok' => true })))

      expect(mcp.connect.request('logging/setLevel')).to eq({ 'ok' => true })
    end

    it 'requires a method' do
      expect { mcp.connect.request('') }.to raise_error(ArgumentError, /Method is required/)
    end
  end

  describe 'errors' do
    it 'includes the BundleUp error code' do
      body = { status: 400, code: 'connection_invalid', message: 'Missing or invalid connection ID' }
      stub_request(:post, url).to_return(status: 400, body: body.to_json)

      expect { mcp.connect.list_tools }.to raise_error(/Missing or invalid connection ID \(connection_invalid\)/)
    end

    it 'falls back to the status when the body is not JSON' do
      stub_request(:post, url).to_return(status: 504, body: 'gateway timeout')

      expect { mcp.connect.list_tools }.to raise_error(/MCP request failed with status 504/)
    end
  end

  describe '#close' do
    it 'deletes the session' do
      stub_session(json_response(rpc(2, result: { 'tools' => [] })), session_id: 'sess_xyz')
      request = stub_request(:delete, url).with(headers: { 'Mcp-Session-Id' => 'sess_xyz' })

      client = mcp.connect
      client.list_tools
      client.close

      expect(request).to have_been_requested
    end

    it 'does not call DELETE without a session' do
      mcp.connect.close

      expect(a_request(:delete, url)).not_to have_been_made
    end
  end
end
