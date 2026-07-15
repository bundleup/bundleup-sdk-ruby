# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BundleUp::Unify::Client do
  describe '#initialize' do
    let(:api_key) { 'test_api_key' }
    let(:connection_id) { 'conn_123' }
    let(:client) { described_class.new(api_key, connection_id) }

    it 'creates a client with api_key and connection_id' do
      expect(client).to be_a(described_class)
    end

    it 'exposes ticketing, chat, git, crm, and drive instances' do # rubocop:disable RSpec/MultipleExpectations
      expect(client.ticketing).to be_a(BundleUp::Unify::Ticketing)
      expect(client.chat).to be_a(BundleUp::Unify::Chat)
      expect(client.git).to be_a(BundleUp::Unify::Git)
      expect(client.crm).to be_a(BundleUp::Unify::CRM)
      expect(client.drive).to be_a(BundleUp::Unify::Drive)
    end

    it 'memoizes each accessor' do # rubocop:disable RSpec/MultipleExpectations
      expect(client.chat).to be(client.chat)
      expect(client.git).to be(client.git)
      expect(client.ticketing).to be(client.ticketing)
      expect(client.crm).to be(client.crm)
      expect(client.drive).to be(client.drive)
    end
  end
end
