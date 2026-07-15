# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BundleUp::Unify::Drive do
  let(:api_key) { 'test_api_key' }
  let(:connection_id) { 'conn_123' }
  let(:instance) { described_class.new(api_key, connection_id) }
  let(:base_url) { 'https://unify.bundleup.io/v1' }

  describe '#files' do
    it 'makes a GET request to files endpoint' do
      stub = stub_request(:get, "#{base_url}/drive/files")
             .with(
               headers: {
                 'Authorization' => "Bearer #{api_key}",
                 'Content-Type' => 'application/json',
                 'BU-Connection-Id' => connection_id
               }
             )
             .to_return(
               status: 200,
               body: '{"data":[{"id":"file_1","name":"report.pdf","is_folder":false}]}',
               headers: { 'Content-Type' => 'application/json' }
             )

      result = instance.files
      expect(result).to eq(
        { 'data' => [{ 'id' => 'file_1', 'name' => 'report.pdf', 'is_folder' => false }] }
      )
      expect(stub).to have_been_requested
    end

    it 'raises error on 401' do
      stub_request(:get, "#{base_url}/drive/files")
        .to_return(status: 401, body: '{"error":"Unauthorized"}')

      expect { instance.files }.to raise_error(Faraday::UnauthorizedError)
    end
  end
end
