# frozen_string_literal: true

module BundleUp
  module Unify
    # Client for helpdesk Unify endpoints (customer support tools).
    class Helpdesk < Base
      # Fetches support tickets from the connected helpdesk.
      def tickets(params = {})
        response = connection.get('helpdesk/tickets') do |req|
          req.params = params
        end

        raise "Failed to fetch helpdesk/tickets: #{response.status}" unless response.success?

        response.body
      end

      # Fetches a single support ticket by ID (a sys_id on ServiceNow).
      def ticket(ticket_id, params = {})
        raise ArgumentError, 'ticket_id is required to fetch a ticket.' if blank?(ticket_id)

        encoded_id = URI.encode_www_form_component(ticket_id)

        response = connection.get("helpdesk/tickets/#{encoded_id}") do |req|
          req.params = params
        end

        raise "Failed to fetch helpdesk/tickets/#{encoded_id}: #{response.status}" unless response.success?

        response.body
      end

      private

      def blank?(value)
        value.nil? || value.to_s.empty?
      end
    end
  end
end
