# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Bundleup::Unify::Chat do
  let(:instance) { described_class.new('test_api_key', 'conn_123') }

  describe '#channels' do
    it 'makes a GET request to channels endpoint' do
      stub = stub_request(:get, 'https://unify.bundleup.io/v1/chat/channels')
             .with(
               headers: {
                 'Authorization' => 'Bearer test_api_key',
                 'BU-Connection-Id' => 'conn_123',
                 'BU-Include-Raw' => 'false'
               }
             )
             .to_return(status: 200, body: '{"data":[]}', headers: { 'Content-Type' => 'application/json' })

      instance.channels

      expect(stub).to have_been_requested
    end

    it 'supports include_raw parameter' do
      stub = stub_request(:get, 'https://unify.bundleup.io/v1/chat/channels')
             .with(
               headers: {
                 'Authorization' => 'Bearer test_api_key',
                 'BU-Connection-Id' => 'conn_123',
                 'BU-Include-Raw' => 'true'
               }
             )
             .to_return(status: 200, body: '{"data":[]}', headers: { 'Content-Type' => 'application/json' })

      instance.channels(include_raw: true)

      expect(stub).to have_been_requested
    end
  end
end

RSpec.describe Bundleup::Unify::Git do
  let(:instance) { described_class.new('test_api_key', 'conn_123') }

  describe '#repos' do
    it 'makes a GET request to repos endpoint' do
      stub = stub_request(:get, 'https://unify.bundleup.io/v1/git/repos')
             .with(
               headers: {
                 'Authorization' => 'Bearer test_api_key',
                 'BU-Connection-Id' => 'conn_123',
                 'BU-Include-Raw' => 'false'
               }
             )
             .to_return(status: 200, body: '{"data":[]}', headers: { 'Content-Type' => 'application/json' })

      instance.repos

      expect(stub).to have_been_requested
    end
  end

  describe '#pulls' do
    it 'makes a GET request with repo_name' do
      stub = stub_request(:get, 'https://unify.bundleup.io/v1/git/pulls?repo_name=owner/repo')
             .with(
               headers: {
                 'Authorization' => 'Bearer test_api_key',
                 'BU-Connection-Id' => 'conn_123',
                 'BU-Include-Raw' => 'false'
               }
             )
             .to_return(status: 200, body: '{"data":[]}', headers: { 'Content-Type' => 'application/json' })

      instance.pulls('owner/repo')

      expect(stub).to have_been_requested
    end
  end

  describe '#tags' do
    it 'makes a GET request with repo_name' do
      stub = stub_request(:get, 'https://unify.bundleup.io/v1/git/tags?repo_name=owner/repo')
             .with(
               headers: {
                 'Authorization' => 'Bearer test_api_key',
                 'BU-Connection-Id' => 'conn_123',
                 'BU-Include-Raw' => 'false'
               }
             )
             .to_return(status: 200, body: '{"data":[]}', headers: { 'Content-Type' => 'application/json' })

      instance.tags('owner/repo')

      expect(stub).to have_been_requested
    end
  end

  describe '#releases' do
    it 'makes a GET request with repo_name' do
      stub = stub_request(:get, 'https://unify.bundleup.io/v1/git/releases?repo_name=owner/repo')
             .with(
               headers: {
                 'Authorization' => 'Bearer test_api_key',
                 'BU-Connection-Id' => 'conn_123',
                 'BU-Include-Raw' => 'false'
               }
             )
             .to_return(status: 200, body: '{"data":[]}', headers: { 'Content-Type' => 'application/json' })

      instance.releases('owner/repo')

      expect(stub).to have_been_requested
    end
  end
end

RSpec.describe Bundleup::Unify::PM do
  let(:instance) { described_class.new('test_api_key', 'conn_123') }

  describe '#issues' do
    it 'makes a GET request to issues endpoint' do
      stub = stub_request(:get, 'https://unify.bundleup.io/v1/pm/issues')
             .with(
               headers: {
                 'Authorization' => 'Bearer test_api_key',
                 'BU-Connection-Id' => 'conn_123',
                 'BU-Include-Raw' => 'false'
               }
             )
             .to_return(status: 200, body: '{"data":[]}', headers: { 'Content-Type' => 'application/json' })

      instance.issues

      expect(stub).to have_been_requested
    end
  end
end
