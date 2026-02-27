# frozen_string_literal: true

module Bundleup
  module Unify
    # Client for project management Unify endpoints.
    class PM < Base
      # Fetches issues from the connected project management tool.
      def issues(params = {})
        response = connection.get('pm/issues') do |req|
          req.params = params
        end

        raise "Failed to fetch pm/issues: #{response.status}" unless response.success?

        response.body
      end
    end
  end
end
