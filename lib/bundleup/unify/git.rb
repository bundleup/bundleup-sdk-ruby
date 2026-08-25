# frozen_string_literal: true

module BundleUp
  module Unify
    # Client for Git Unify endpoints.
    class Git < Base
      # Fetches repositories from the connected Git provider.
      def repos(params = {})
        response = connection.get('git/repos') do |req|
          req.params = params
        end

        raise "Failed to fetch git/repos: #{response.status}" unless response.success?

        response.body
      end

      # Fetches pull requests for a specific repository from the connected Git provider.
      def pulls(repo_name, params = {})
        raise ArgumentError, 'repo_name is required to fetch pulls.' if blank?(repo_name)

        encoded_repo_name = URI.encode_www_form_component(repo_name)

        response = connection.get("git/repos/#{encoded_repo_name}/pulls") do |req|
          req.params = params
        end

        raise "Failed to fetch git/repos/#{encoded_repo_name}/pulls: #{response.status}" unless response.success?

        response.body
      end

      # Fetches tags for a specific repository from the connected Git provider.
      def tags(repo_name, params = {})
        raise ArgumentError, 'repo_name is required to fetch tags.' if blank?(repo_name)

        encoded_repo_name = URI.encode_www_form_component(repo_name)

        response = connection.get("git/repos/#{encoded_repo_name}/tags") do |req|
          req.params = params
        end

        raise "Failed to fetch git/repos/#{encoded_repo_name}/tags: #{response.status}" unless response.success?

        response.body
      end

      # Fetches releases for a specific repository from the connected Git provider.
      def releases(repo_name, params = {})
        raise ArgumentError, 'repo_name is required to fetch releases.' if blank?(repo_name)

        encoded_repo_name = URI.encode_www_form_component(repo_name)

        response = connection.get("git/repos/#{encoded_repo_name}/releases") do |req|
          req.params = params
        end

        raise "Failed to fetch git/repos/#{encoded_repo_name}/releases: #{response.status}" unless response.success?

        response.body
      end

      # Fetches branches for a specific repository from the connected Git provider.
      def branches(repo_name, params = {})
        raise ArgumentError, 'repo_name is required to fetch branches.' if blank?(repo_name)

        encoded_repo_name = URI.encode_www_form_component(repo_name)

        response = connection.get("git/repos/#{encoded_repo_name}/branches") do |req|
          req.params = params
        end

        raise "Failed to fetch git/repos/#{encoded_repo_name}/branches: #{response.status}" unless response.success?

        response.body
      end

      # Fetches commits for a specific repository from the connected Git provider.
      def commits(repo_name, params = {})
        raise ArgumentError, 'repo_name is required to fetch commits.' if blank?(repo_name)

        encoded_repo_name = URI.encode_www_form_component(repo_name)

        response = connection.get("git/repos/#{encoded_repo_name}/commits") do |req|
          req.params = params
        end

        raise "Failed to fetch git/repos/#{encoded_repo_name}/commits: #{response.status}" unless response.success?

        response.body
      end

      private

      def blank?(value)
        value.nil? || value.to_s.empty?
      end
    end
  end
end
