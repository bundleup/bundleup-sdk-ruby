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

    it 'exposes me as a method rather than a namespace' do
      expect(client.method(:me).arity).to eq(-1)
    end

    it 'fetches the connected account through the root me endpoint' do
      stub = stub_request(:get, 'https://unify.bundleup.io/v1/me')
             .to_return(
               status: 200,
               body: '{"data":{"id":"u_1","name":"Ada","email":null,"avatar_url":null}}',
               headers: { 'Content-Type' => 'application/json' }
             )

      expect(client.me).to eq(
        { 'data' => { 'id' => 'u_1', 'name' => 'Ada', 'email' => nil, 'avatar_url' => nil } }
      )
      expect(stub).to have_been_requested
    end
  end
end
