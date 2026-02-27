# frozen_string_literal: true

require 'bundleup'

api_key = ENV['BUNDLEUP_API_KEY']

if api_key.nil? || api_key.empty?
  abort 'BUNDLEUP_API_KEY is required'
end

client = Bundleup::Client.new(api_key)

puts 'BundleUp Ruby SDK: basic usage'

begin
  connections = client.connections.list
  puts "Connections: #{connections.length}"
rescue StandardError => e
  warn "Failed to list connections: #{e.message}"
end

begin
  integrations = client.integrations.list
  puts "Integrations: #{integrations.length}"
rescue StandardError => e
  warn "Failed to list integrations: #{e.message}"
end

begin
  webhooks = client.webhooks.list
  puts "Webhooks: #{webhooks.length}"
rescue StandardError => e
  warn "Failed to list webhooks: #{e.message}"
end
