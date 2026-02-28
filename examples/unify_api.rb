# frozen_string_literal: true

require 'bundleup'

api_key = ENV['BUNDLEUP_API_KEY']
connection_id = ENV['BUNDLEUP_CONNECTION_ID']

if api_key.nil? || api_key.empty?
  abort 'BUNDLEUP_API_KEY is required'
end

if connection_id.nil? || connection_id.empty?
  abort 'BUNDLEUP_CONNECTION_ID is required for unify example'
end

chat = BundleUp::Unify::Chat.new(api_key, connection_id)
git = BundleUp::Unify::Git.new(api_key, connection_id)
pm = BundleUp::Unify::PM.new(api_key, connection_id)

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
  issues = pm.issues(limit: 10)
  puts "PM issues: #{issues['data']&.length || 0}"
rescue StandardError => e
  warn "Failed to fetch PM issues: #{e.message}"
end
