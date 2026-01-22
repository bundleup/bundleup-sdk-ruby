# frozen_string_literal: true

module Bundleup
  module Unify
    # Git resource for unified git operations
    class Git < Base
      # List repositories
      #
      # @param params [Hash] Query parameters
      # @option params [Integer] :limit Number of results to return
      # @option params [String] :cursor Pagination cursor
      # @option params [Boolean] :include_raw Include raw response from the integration
      # @return [Hash] Repositories data with pagination info
      def repos(params = {})
        include_raw = params.delete(:include_raw) || false
        request(:get, "/#{API_VERSION}/git/repos", params, include_raw: include_raw)
      end

      # List pull requests
      #
      # @param repo_name [String] Repository name
      # @param params [Hash] Query parameters
      # @option params [Integer] :limit Number of results to return
      # @option params [String] :cursor Pagination cursor
      # @option params [Boolean] :include_raw Include raw response from the integration
      # @return [Hash] Pull requests data with pagination info
      def pulls(repo_name, params = {})
        include_raw = params.delete(:include_raw) || false
        params[:repo_name] = repo_name
        request(:get, "/#{API_VERSION}/git/pulls", params, include_raw: include_raw)
      end

      # List tags
      #
      # @param repo_name [String] Repository name
      # @param params [Hash] Query parameters
      # @option params [Integer] :limit Number of results to return
      # @option params [String] :cursor Pagination cursor
      # @option params [Boolean] :include_raw Include raw response from the integration
      # @return [Hash] Tags data with pagination info
      def tags(repo_name, params = {})
        include_raw = params.delete(:include_raw) || false
        params[:repo_name] = repo_name
        request(:get, "/#{API_VERSION}/git/tags", params, include_raw: include_raw)
      end

      # List releases
      #
      # @param repo_name [String] Repository name
      # @param params [Hash] Query parameters
      # @option params [Integer] :limit Number of results to return
      # @option params [String] :cursor Pagination cursor
      # @option params [Boolean] :include_raw Include raw response from the integration
      # @return [Hash] Releases data with pagination info
      def releases(repo_name, params = {})
        include_raw = params.delete(:include_raw) || false
        params[:repo_name] = repo_name
        request(:get, "/#{API_VERSION}/git/releases", params, include_raw: include_raw)
      end
    end
  end
end
