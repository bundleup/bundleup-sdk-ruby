# frozen_string_literal: true

module Bundleup
  module Resources
    # Client for integration API endpoints.
    class Integration < Base
      public :list, :retrieve

      private

      def resource_name
        'integrations'
      end
    end
  end
end
