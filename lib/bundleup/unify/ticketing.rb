# frozen_string_literal: true

module BundleUp
  module Unify
    # Client for ticketing Unify endpoints.
    class Ticketing < Base
      # Fetches tickets from the connected ticketing tool.
      def tickets(params = {})
        response = connection.get('ticketing/tickets') do |req|
          req.params = params
        end

        raise "Failed to fetch ticketing/tickets: #{response.status}" unless response.success?

        response.body
      end
    end
  end
end
