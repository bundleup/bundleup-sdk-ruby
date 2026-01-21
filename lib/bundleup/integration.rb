# frozen_string_literal: true

module Bundleup
  # Integration resource for managing integrations
  class Integration < Base
    private

    def resource_name
      'integrations'
    end
  end
end
