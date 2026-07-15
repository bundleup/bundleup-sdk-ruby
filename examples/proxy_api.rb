# frozen_string_literal: true

require 'bundleup'

api_key = ENV.fetch('BUNDLEUP_API_KEY', nil)
connection_id = ENV.fetch('BUNDLEUP_CONNECTION_ID', nil)
path = ENV.fetch('BUNDLEUP_PROXY_PATH', '/users')

abort 'BUNDLEUP_API_KEY is required' if api_key.nil? || api_key.empty?

abort 'BUNDLEUP_CONNECTION_ID is required for proxy example' if connection_id.nil? || connection_id.empty?

client = BundleUp::Client.new(api_key)
proxy = client.proxy(connection_id)

puts "Proxy GET #{path}"

begin
  response = proxy.get(path)
  puts "Status: #{response.status}"
  puts "Body: #{response.body}"
rescue StandardError => e
  warn "Proxy request failed: #{e.message}"
end
