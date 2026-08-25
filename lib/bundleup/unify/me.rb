# frozen_string_literal: true

module BundleUp
  module Unify
    # Client for the root-level identity endpoint.
    #
    # `me` is the one unified method every provider implements, so the API mounts
    # it at the root rather than under a vertical. It is exposed on the Unify
    # client as `unify.me` rather than as a namespace.
    class Me < Base
      # Fetches the account the connection is authenticated as.
      #
      # Providers that authorize per workspace, portal, tenant or company return
      # that account instead of a user, and fields the provider does not expose
      # come back as nil.
      def get(params = {})
        response = connection.get('me') do |req|
          req.params = params
        end

        raise "Failed to fetch me: #{response.status}" unless response.success?

        response.body
      end
    end
  end
end
