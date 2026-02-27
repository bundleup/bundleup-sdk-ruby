# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Bundleup do
  describe '::VERSION' do
    it 'has a version number' do
      expect(Bundleup::VERSION).not_to be_nil
      expect(Bundleup::VERSION).to match(/\d+\.\d+\.\d+/)
    end
  end
end
