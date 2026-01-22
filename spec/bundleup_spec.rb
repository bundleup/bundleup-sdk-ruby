# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Bundleup do
  describe '::VERSION' do
    it 'has a version number' do
      expect(Bundleup::VERSION).not_to be nil
      expect(Bundleup::VERSION).to match(/\d+\.\d+\.\d+/)
    end
  end

  describe '.new' do
    it 'creates a new Client instance' do
      client = described_class.new('test_api_key')
      expect(client).to be_a(Bundleup::Client)
    end
  end
end
