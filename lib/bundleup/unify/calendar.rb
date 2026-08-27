# frozen_string_literal: true

module BundleUp
  module Unify
    # Client for Calendar-related Unify endpoints.
    class Calendar < Base
      # Fetches events from the connected calendar provider.
      #
      # +params+ must carry +starts_after+ and +starts_before+ (ISO 8601) —
      # the endpoint refuses an unbounded listing.
      def events(params = {})
        raise ArgumentError, 'starts_after and starts_before are required to fetch events.' if window_missing?(params)

        response = connection.get('calendar/events') do |req|
          req.params = params
        end

        raise "Failed to fetch calendar/events: #{response.status}" unless response.success?

        response.body
      end

      private

      def window_missing?(params)
        params ||= {}

        %i[starts_after starts_before].any? do |key|
          value = params[key] || params[key.to_s]
          value.nil? || value.to_s.empty?
        end
      end
    end
  end
end
