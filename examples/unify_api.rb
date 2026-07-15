# frozen_string_literal: true

require 'bundleup'

api_key = ENV.fetch('BUNDLEUP_API_KEY', nil)
connection_id = ENV.fetch('BUNDLEUP_CONNECTION_ID', nil)

abort 'BUNDLEUP_API_KEY is required' if api_key.nil? || api_key.empty?

abort 'BUNDLEUP_CONNECTION_ID is required for unify example' if connection_id.nil? || connection_id.empty?

ticketing = BundleUp::Unify::Ticketing.new(api_key, connection_id)
client = BundleUp::Client.new(api_key)
unify = client.unify(connection_id)

puts 'Unify API example'

begin
  users = unify.chat.users(limit: 10)
  puts "Chat users: #{users['data']&.length || 0}"
rescue StandardError => e
  warn "Failed to fetch chat users: #{e.message}"
end

begin
  channels = unify.chat.channels(limit: 10)
  puts "Chat channels: #{channels['data']&.length || 0}"
rescue StandardError => e
  warn "Failed to fetch chat channels: #{e.message}"
end

begin
  repos = unify.git.repos(limit: 10)
  puts "Git repos: #{repos['data']&.length || 0}"
rescue StandardError => e
  warn "Failed to fetch git repos: #{e.message}"
end

begin
  tickets = ticketing.tickets(limit: 10)
  puts "Ticketing tickets: #{tickets['data']&.length || 0}"
rescue StandardError => e
  warn "Failed to fetch tickets: #{e.message}"
end

begin
  companies = unify.crm.companies(limit: 10)
  puts "CRM companies: #{companies['data']&.length || 0}"
rescue StandardError => e
  warn "Failed to fetch CRM companies: #{e.message}"
end

begin
  files = unify.drive.files(limit: 10)
  puts "Drive files: #{files['data']&.length || 0}"
rescue StandardError => e
  warn "Failed to fetch Drive files: #{e.message}"
end
