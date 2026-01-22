# frozen_string_literal: true

module Bundleup
  # Webhook resource for managing webhooks
  class Webhook < Base
    private

    def resource_name
      'webhooks'
    end
  end
end
