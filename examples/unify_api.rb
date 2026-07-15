# frozen_string_literal: true

require 'bundleup'

api_key = ENV.fetch('BUNDLEUP_API_KEY', nil)
connection_id = ENV.fetch('BUNDLEUP_CONNECTION_ID', nil)

abort 'BUNDLEUP_API_KEY is required' if api_key.nil? || api_key.empty?

abort 'BUNDLEUP_CONNECTION_ID is required for unify example' if connection_id.nil? || connection_id.empty?

chat = BundleUp::Unify::Chat.new(api_key, connection_id)
git = BundleUp::Unify::Git.new(api_key, connection_id)
ticketing = BundleUp::Unify::Ticketing.new(api_key, connection_id)

puts 'Unify API example'

begin
  channels = chat.channels(limit: 10)
  puts "Chat channels: #{channels['data']&.length || 0}"
rescue StandardError => e
  warn "Failed to fetch chat channels: #{e.message}"
end

begin
  repos = git.repos(limit: 10)
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
