# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Bundleup::Client do
  describe '#initialize' do
    it 'creates a client with a valid API key' do
      client = described_class.new('test_api_key')
      expect(client.api_key).to eq('test_api_key')
    end

    it 'raises an error when API key is nil' do
      expect do
        described_class.new(nil)
      end.to raise_error(ArgumentError, 'API key is required to initialize BundleUp SDK.')
    end

    it 'raises an error when API key is empty' do
      expect do
        described_class.new('')
      end.to raise_error(ArgumentError, 'API key is required to initialize BundleUp SDK.')
    end
  end

  describe '#connections' do
    let(:client) { described_class.new('test_api_key') }

    it 'returns a Connection instance' do
      expect(client.connections).to be_a(Bundleup::Connection)
    end

    it 'memoizes the instance' do
      expect(client.connections).to be(client.connections)
    end
  end

  describe '#integrations' do
    let(:client) { described_class.new('test_api_key') }

    it 'returns an Integration instance' do
      expect(client.integrations).to be_a(Bundleup::Integration)
    end

    it 'memoizes the instance' do
      expect(client.integrations).to be(client.integrations)
    end
  end

  describe '#webhooks' do
    let(:client) { described_class.new('test_api_key') }

    it 'returns a Webhook instance' do
      expect(client.webhooks).to be_a(Bundleup::Webhook)
    end

    it 'memoizes the instance' do
      expect(client.webhooks).to be(client.webhooks)
    end
  end

  describe '#proxy' do
    let(:client) { described_class.new('test_api_key') }

    it 'returns a Proxy instance' do
      proxy = client.proxy('conn_123')
      expect(proxy).to be_a(Bundleup::Proxy)
      expect(proxy.connection_id).to eq('conn_123')
    end

    it 'raises an error when connection_id is nil' do
      expect do
        client.proxy(nil)
      end.to raise_error(ArgumentError, 'Connection ID is required to create a Proxy instance.')
    end

    it 'raises an error when connection_id is empty' do
      expect { client.proxy('') }.to raise_error(ArgumentError, 'Connection ID is required to create a Proxy instance.')
    end

    it 'does not memoize the instance' do
      expect(client.proxy('conn_123')).not_to be(client.proxy('conn_123'))
    end
  end

  describe '#unify' do
    let(:client) { described_class.new('test_api_key') }

    it 'returns a hash with chat, git, and pm instances' do
      unify = client.unify('conn_123')
      expect(unify).to be_a(Hash)
      expect(unify[:chat]).to be_a(Bundleup::Unify::Chat)
      expect(unify[:git]).to be_a(Bundleup::Unify::Git)
      expect(unify[:pm]).to be_a(Bundleup::Unify::PM)
    end

    it 'raises an error when connection_id is nil' do
      expect do
        client.unify(nil)
      end.to raise_error(ArgumentError, 'Connection ID is required to create a Unify instance.')
    end

    it 'raises an error when connection_id is empty' do
      expect { client.unify('') }.to raise_error(ArgumentError, 'Connection ID is required to create a Unify instance.')
    end
  end
end
