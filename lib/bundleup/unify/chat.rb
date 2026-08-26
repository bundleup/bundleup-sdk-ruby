# frozen_string_literal: true

module BundleUp
  module Unify
    # Client for chat-related Unify endpoints.
    class Chat < Base
      # Fetches users from the connected chat provider.
      def users(params = {})
        response = connection.get('chat/users') do |req|
          req.params = params
        end

        raise "Failed to fetch chat/users: #{response.status}" unless response.success?

        response.body
      end

      # Fetches channels from the connected chat provider.
      def channels(params = {})
        response = connection.get('chat/channels') do |req|
          req.params = params
        end

        raise "Failed to fetch chat/channels: #{response.status}" unless response.success?

        response.body
      end

      # Fetches messages in a channel from the connected chat provider.
      #
      # Newest first. +author.name+ is nil on Slack, which returns only a user
      # id on a message.
      def messages(channel_id, params = {})
        raise ArgumentError, 'channel_id is required to fetch messages.' if channel_id.nil?

        encoded_channel_id = URI.encode_www_form_component(channel_id)

        response = connection.get("chat/channels/#{encoded_channel_id}/messages") do |req|
          req.params = params
        end

        unless response.success?
          raise "Failed to fetch chat/channels/#{encoded_channel_id}/messages: #{response.status}"
        end

        response.body
      end

      # Sends a message to a channel on the connected chat provider.
      def message(channel_id, text)
        raise ArgumentError, 'channel_id is required to send a message.' if channel_id.nil?

        encoded_channel_id = URI.encode_www_form_component(channel_id)

        response = connection.post("chat/channels/#{encoded_channel_id}/message", { text: text }.to_json)

        raise "Failed to post chat/channels/#{encoded_channel_id}/message: #{response.status}" unless response.success?

        response.body
      end
    end
  end
end
