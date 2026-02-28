# frozen_string_literal: true

module BundleUp
  module Resources
    # Client for webhook API endpoints.
    class Webhook < Base
      public :list, :retrieve, :create, :update, :delete

      private

      def resource_name
        'webhooks'
      end
    end
  end
end
