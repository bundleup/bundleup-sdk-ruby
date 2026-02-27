# frozen_string_literal: true

require 'bundleup'

api_key = ENV['BUNDLEUP_API_KEY']
connection_id = ENV['BUNDLEUP_CONNECTION_ID']
path = ENV.fetch('BUNDLEUP_PROXY_PATH', '/users')

if api_key.nil? || api_key.empty?
  abort 'BUNDLEUP_API_KEY is required'
end

if connection_id.nil? || connection_id.empty?
  abort 'BUNDLEUP_CONNECTION_ID is required for proxy example'
end

client = Bundleup::Client.new(api_key)
proxy = client.proxy(connection_id)

puts "Proxy GET #{path}"

begin
  response = proxy.get(path)
  puts "Status: #{response.status}"
  puts "Body: #{response.body}"
rescue StandardError => e
  warn "Proxy request failed: #{e.message}"
end
