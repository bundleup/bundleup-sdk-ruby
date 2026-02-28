# frozen_string_literal: true

module BundleUp
  module Resources
    # Client for connection API endpoints.
    class Connection < Base
      public :list, :retrieve, :delete

      private

      def resource_name
        'connections'
      end
    end
  end
end
