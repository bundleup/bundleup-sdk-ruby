# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BundleUp::Unify::Chat do
  let(:api_key) { 'test_api_key' }
  let(:connection_id) { 'conn_123' }
  let(:instance) { described_class.new(api_key, connection_id) }
  let(:base_url) { 'https://unify.bundleup.io/v1' }

  describe '#users' do
    it 'makes a GET request to users endpoint' do
      stub = stub_request(:get, "#{base_url}/chat/users")
             .with(
               headers: {
                 'Authorization' => "Bearer #{api_key}",
                 'Content-Type' => 'application/json',
                 'BU-Connection-Id' => connection_id
               }
             )
             .to_return(
               status: 200,
               body: '{"data":[{"id":"u_1","name":"Jane Doe"}]}',
               headers: { 'Content-Type' => 'application/json' }
             )

      result = instance.users
      expect(result).to eq({ 'data' => [{ 'id' => 'u_1', 'name' => 'Jane Doe' }] })
      expect(stub).to have_been_requested
    end

    it 'raises error on 401' do
      stub_request(:get, "#{base_url}/chat/users")
        .to_return(status: 401, body: '{"error":"Unauthorized"}')

      expect { instance.users }.to raise_error(Faraday::UnauthorizedError)
    end
  end

  describe '#channels' do
    it 'makes a GET request to channels endpoint' do
      stub = stub_request(:get, "#{base_url}/chat/channels")
             .with(
               headers: {
                 'Authorization' => "Bearer #{api_key}",
                 'Content-Type' => 'application/json',
                 'BU-Connection-Id' => connection_id
               }
             )
             .to_return(
               status: 200,
               body: '{"data":[{"id":"ch_1","name":"general"}]}',
               headers: { 'Content-Type' => 'application/json' }
             )

      result = instance.channels
      expect(result).to eq({ 'data' => [{ 'id' => 'ch_1', 'name' => 'general' }] })
      expect(stub).to have_been_requested
    end

    it 'supports additional query parameters' do
      stub = stub_request(:get, "#{base_url}/chat/channels?limit=10")
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

      instance.channels(limit: 10)
      expect(stub).to have_been_requested
    end

    it 'raises error on 401' do
      stub_request(:get, "#{base_url}/chat/channels")
        .to_return(status: 401, body: '{"error":"Unauthorized"}')

      expect { instance.channels }.to raise_error(Faraday::UnauthorizedError)
    end
  end

  describe '#message' do
    it 'makes a POST request to the channel message endpoint' do
      stub = stub_request(:post, "#{base_url}/chat/channels/ch_1/message")
             .with(
               body: { text: 'Hello!' }.to_json,
               headers: {
                 'Authorization' => "Bearer #{api_key}",
                 'Content-Type' => 'application/json',
                 'BU-Connection-Id' => connection_id
               }
             )
             .to_return(
               status: 200,
               body: '{"data":{"ok":true}}',
               headers: { 'Content-Type' => 'application/json' }
             )

      result = instance.message('ch_1', 'Hello!')
      expect(result).to eq({ 'data' => { 'ok' => true } })
      expect(stub).to have_been_requested
    end

    it 'raises an ArgumentError when channel_id is missing' do
      expect { instance.message(nil, 'Hello!') }.to raise_error(ArgumentError)
    end

    it 'encodes the channel id in the URL' do
      stub = stub_request(:post, "#{base_url}/chat/channels/general%2Froom/message")
             .to_return(status: 200, body: '{"data":{}}', headers: { 'Content-Type' => 'application/json' })

      instance.message('general/room', 'Hello!')
      expect(stub).to have_been_requested
    end
  end

  describe '#messages' do
    it 'makes a GET request to the channel messages endpoint' do
      stub = stub_request(:get, "#{base_url}/chat/channels/ch_1/messages")
             .with(
               headers: {
                 'Authorization' => "Bearer #{api_key}",
                 'Content-Type' => 'application/json',
                 'BU-Connection-Id' => connection_id
               }
             )
             .to_return(
               status: 200,
               body: '{"data":[{"id":"1755712345.123456","text":"Hello!"}]}',
               headers: { 'Content-Type' => 'application/json' }
             )

      result = instance.messages('ch_1')
      expect(result).to eq({ 'data' => [{ 'id' => '1755712345.123456', 'text' => 'Hello!' }] })
      expect(stub).to have_been_requested
    end

    it 'passes paging options through as query params' do
      stub = stub_request(:get, "#{base_url}/chat/channels/ch_1/messages")
             .with(query: { limit: 20, after: 'cursor_1' })
             .to_return(status: 200, body: '{"data":[]}', headers: { 'Content-Type' => 'application/json' })

      instance.messages('ch_1', limit: 20, after: 'cursor_1')
      expect(stub).to have_been_requested
    end

    it 'raises an ArgumentError when channel_id is missing' do
      expect { instance.messages(nil) }
        .to raise_error(ArgumentError, 'channel_id is required to fetch messages.')
    end

    it 'encodes the channel id in the URL' do
      stub = stub_request(:get, "#{base_url}/chat/channels/general%2Froom/messages")
             .to_return(status: 200, body: '{"data":[]}', headers: { 'Content-Type' => 'application/json' })

      instance.messages('general/room')
      expect(stub).to have_been_requested
    end
  end
end
