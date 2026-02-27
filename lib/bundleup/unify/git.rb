# frozen_string_literal: true

module Bundleup
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
        encoded_repo_name = URI.encode_www_form_component(repo_name)

        response = connection.get("git/repos/#{encoded_repo_name}/pulls") do |req|
          req.params = params
        end

        raise "Failed to fetch git/repos/#{encoded_repo_name}/pulls: #{response.status}" unless response.success?

        response.body
      end

      # Fetches tags for a specific repository from the connected Git provider.
      def tags(repo_name, params = {})
        encoded_repo_name = URI.encode_www_form_component(repo_name)

        response = connection.get("git/repos/#{encoded_repo_name}/tags") do |req|
          req.params = params
        end

        raise "Failed to fetch git/repos/#{encoded_repo_name}/tags: #{response.status}" unless response.success?

        response.body
      end

      # Fetches releases for a specific repository from the connected Git provider.
      def releases(repo_name, params = {})
        encoded_repo_name = URI.encode_www_form_component(repo_name)

        response = connection.get("git/repos/#{encoded_repo_name}/releases") do |req|
          req.params = params
        end

        raise "Failed to fetch git/repos/#{encoded_repo_name}/releases: #{response.status}" unless response.success?

        response.body
      end
    end
  end
end
