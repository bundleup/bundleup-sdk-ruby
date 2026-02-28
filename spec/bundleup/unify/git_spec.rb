# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BundleUp::Unify::Git do
  let(:api_key) { 'test_api_key' }
  let(:connection_id) { 'conn_123' }
  let(:instance) { described_class.new(api_key, connection_id) }
  let(:base_url) { 'https://unify.bundleup.io/v1' }

  describe '#repos' do
    it 'makes a GET request to repos endpoint' do
      stub = stub_request(:get, "#{base_url}/git/repos")
             .with(
               headers: {
                 'Authorization' => "Bearer #{api_key}",
                 'Content-Type' => 'application/json',
                 'BU-Connection-Id' => connection_id
               }
             )
             .to_return(
               status: 200,
               body: '{"data":[{"id":"repo_1","name":"my-repo"}]}',
               headers: { 'Content-Type' => 'application/json' }
             )

      result = instance.repos
      expect(result).to eq({ 'data' => [{ 'id' => 'repo_1', 'name' => 'my-repo' }] })
      expect(stub).to have_been_requested
    end

    it 'supports additional query parameters' do
      stub = stub_request(:get, "#{base_url}/git/repos?visibility=public")
             .with(
               headers: {
                 'Authorization' => "Bearer #{api_key}",
                 'BU-Connection-Id' => connection_id
               }
             )
             .to_return(status: 200, body: '{"data":[]}', headers: { 'Content-Type' => 'application/json' })

      instance.repos(visibility: 'public')
      expect(stub).to have_been_requested
    end
  end

  describe '#pulls' do
    it 'makes a GET request with encoded repo name' do
      stub = stub_request(:get, "#{base_url}/git/repos/owner%2Frepo/pulls")
             .with(
               headers: {
                 'Authorization' => "Bearer #{api_key}",
                 'Content-Type' => 'application/json',
                 'BU-Connection-Id' => connection_id
               }
             )
             .to_return(
               status: 200,
               body: '{"data":[{"id":"pr_1","title":"Fix bug"}]}',
               headers: { 'Content-Type' => 'application/json' }
             )

      result = instance.pulls('owner/repo')
      expect(result).to eq({ 'data' => [{ 'id' => 'pr_1', 'title' => 'Fix bug' }] })
      expect(stub).to have_been_requested
    end

    it 'supports additional query parameters' do
      stub = stub_request(:get, "#{base_url}/git/repos/owner%2Frepo/pulls?state=open")
             .to_return(status: 200, body: '{"data":[]}', headers: { 'Content-Type' => 'application/json' })

      instance.pulls('owner/repo', state: 'open')
      expect(stub).to have_been_requested
    end
  end

  describe '#tags' do
    it 'makes a GET request with encoded repo name' do
      stub = stub_request(:get, "#{base_url}/git/repos/owner%2Frepo/tags")
             .with(
               headers: {
                 'Authorization' => "Bearer #{api_key}",
                 'Content-Type' => 'application/json',
                 'BU-Connection-Id' => connection_id
               }
             )
             .to_return(
               status: 200,
               body: '{"data":[{"name":"v1.0.0"}]}',
               headers: { 'Content-Type' => 'application/json' }
             )

      result = instance.tags('owner/repo')
      expect(result).to eq({ 'data' => [{ 'name' => 'v1.0.0' }] })
      expect(stub).to have_been_requested
    end
  end

  describe '#releases' do
    it 'makes a GET request with encoded repo name' do
      stub = stub_request(:get, "#{base_url}/git/repos/owner%2Frepo/releases")
             .with(
               headers: {
                 'Authorization' => "Bearer #{api_key}",
                 'Content-Type' => 'application/json',
                 'BU-Connection-Id' => connection_id
               }
             )
             .to_return(
               status: 200,
               body: '{"data":[{"tag":"v1.0.0","name":"Release 1.0"}]}',
               headers: { 'Content-Type' => 'application/json' }
             )

      result = instance.releases('owner/repo')
      expect(result).to eq({ 'data' => [{ 'tag' => 'v1.0.0', 'name' => 'Release 1.0' }] })
      expect(stub).to have_been_requested
    end

    it 'raises error on 404' do
      stub_request(:get, "#{base_url}/git/repos/owner%2Finvalid/releases")
        .to_return(status: 404, body: '{"error":"Repository not found"}')

      expect { instance.releases('owner/invalid') }.to raise_error(Faraday::ResourceNotFound)
    end
  end
end
