# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Bundleup::Unify::Client do
  describe '#initialize' do
    let(:api_key) { 'test_api_key' }
    let(:connection_id) { 'conn_123' }
    let(:client) { described_class.new(api_key, connection_id) }

    it 'creates a client with api_key and connection_id' do
      expect(client).to be_a(described_class)
    end

    it 'initializes pm, chat, and git instances' do
      expect(client.instance_variable_get(:@pm)).to be_a(Bundleup::Unify::PM)
      expect(client.instance_variable_get(:@chat)).to be_a(Bundleup::Unify::Chat)
      expect(client.instance_variable_get(:@git)).to be_a(Bundleup::Unify::Git)
    end
  end
end
