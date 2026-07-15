# frozen_string_literal: true

module BundleUp
  module Unify
    # Client for CRM-related Unify endpoints.
    class CRM < Base
      # Fetches companies from the connected CRM provider.
      def companies(params = {})
        response = connection.get('crm/companies') do |req|
          req.params = params
        end

        raise "Failed to fetch crm/companies: #{response.status}" unless response.success?

        response.body
      end

      # Fetches contacts from the connected CRM provider.
      def contacts(params = {})
        response = connection.get('crm/contacts') do |req|
          req.params = params
        end

        raise "Failed to fetch crm/contacts: #{response.status}" unless response.success?

        response.body
      end
    end
  end
end
