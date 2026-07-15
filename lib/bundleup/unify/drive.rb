# frozen_string_literal: true

module BundleUp
  module Unify
    # Client for Drive-related Unify endpoints.
    class Drive < Base
      # Fetches files from the connected Drive provider.
      def files(params = {})
        response = connection.get('drive/files') do |req|
          req.params = params
        end

        raise "Failed to fetch drive/files: #{response.status}" unless response.success?

        response.body
      end
    end
  end
end
