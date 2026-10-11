# frozen_string_literal: true

module BundleUp
  module Unify
    # Client for tasks Unify endpoints (issue trackers and project tools).
    class Tasks < Base
      # Fetches tasks from the connected issue tracker or project tool.
      def tasks(params = {})
        response = connection.get('tasks/tasks') do |req|
          req.params = params
        end

        raise "Failed to fetch tasks/tasks: #{response.status}" unless response.success?

        response.body
      end

      # Fetches a single task by ID from the connected issue tracker or project tool.
      #
      # Not supported by Basecamp, whose API only serves a to-do underneath its
      # project — an id on its own cannot address one.
      def task(task_id, params = {})
        raise ArgumentError, 'task_id is required to fetch a task.' if blank?(task_id)

        encoded_id = URI.encode_www_form_component(task_id)

        response = connection.get("tasks/tasks/#{encoded_id}") do |req|
          req.params = params
        end

        raise "Failed to fetch tasks/tasks/#{encoded_id}: #{response.status}" unless response.success?

        response.body
      end

      # Fetches projects from the connected issue tracker or project tool.
      def projects(params = {})
        response = connection.get('tasks/projects') do |req|
          req.params = params
        end

        raise "Failed to fetch tasks/projects: #{response.status}" unless response.success?

        response.body
      end

      private

      def blank?(value)
        value.nil? || value.to_s.empty?
      end
    end
  end
end
