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

      # Fetches a single ticket by ID from the connected ticketing tool.
      #
      # Not supported by Basecamp, whose API only serves a to-do underneath its
      # project — an id on its own cannot address one.
      def ticket(ticket_id, params = {})
        raise ArgumentError, 'ticket_id is required to fetch a ticket.' if blank?(ticket_id)

        encoded_id = URI.encode_www_form_component(ticket_id)

        response = connection.get("ticketing/tickets/#{encoded_id}") do |req|
          req.params = params
        end

        raise "Failed to fetch ticketing/tickets/#{encoded_id}: #{response.status}" unless response.success?

        response.body
      end

      private

      def blank?(value)
        value.nil? || value.to_s.empty?
      end
    end
  end
end
