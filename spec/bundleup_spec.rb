# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BundleUp do
  describe '::VERSION' do
    it 'has a version number' do
      expect(BundleUp::VERSION).not_to be_nil
      expect(BundleUp::VERSION).to match(/\d+\.\d+\.\d+/)
    end
  end
end
