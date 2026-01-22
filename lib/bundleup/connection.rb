# frozen_string_literal: true

module Bundleup
  # Connection resource for managing connections
  class Connection < Base
    private

    def resource_name
      'connections'
    end
  end
end
