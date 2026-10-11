# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BundleUp::Unify::Tasks do
  let(:api_key) { 'test_api_key' }
  let(:connection_id) { 'conn_123' }
  let(:instance) { described_class.new(api_key, connection_id) }
  let(:base_url) { 'https://unify.bundleup.io/v1' }

  describe '#tasks' do
    it 'makes a GET request to tasks endpoint' do
      stub = stub_request(:get, "#{base_url}/tasks/tasks")
             .with(
               headers: {
                 'Authorization' => "Bearer #{api_key}",
                 'Content-Type' => 'application/json',
                 'BU-Connection-Id' => connection_id
               }
             )
             .to_return(
               status: 200,
               body: '{"data":[{"id":"task_1","title":"Bug fix"}]}',
               headers: { 'Content-Type' => 'application/json' }
             )

      result = instance.tasks
      expect(result).to eq({ 'data' => [{ 'id' => 'task_1', 'title' => 'Bug fix' }] })
      expect(stub).to have_been_requested
    end

    it 'supports additional query parameters' do
      stub = stub_request(:get, "#{base_url}/tasks/tasks?status=open&assignee=john")
             .with(
               headers: {
                 'Authorization' => "Bearer #{api_key}",
                 'Content-Type' => 'application/json',
                 'BU-Connection-Id' => connection_id
               }
             )
             .to_return(
               status: 200,
               body: '{"data":[]}',
               headers: { 'Content-Type' => 'application/json' }
             )

      instance.tasks(status: 'open', assignee: 'john')
      expect(stub).to have_been_requested
    end

    it 'raises error on 401' do
      stub_request(:get, "#{base_url}/tasks/tasks")
        .to_return(status: 401, body: '{"error":"Unauthorized"}')

      expect { instance.tasks }.to raise_error(Faraday::UnauthorizedError)
    end

    it 'raises error on 429 rate limit' do
      stub_request(:get, "#{base_url}/tasks/tasks")
        .to_return(status: 429, body: '{"error":"Rate limit exceeded"}')

      expect { instance.tasks }.to raise_error(Faraday::TooManyRequestsError)
    end
  end

  describe '#task' do
    it 'makes a GET request to the single task endpoint' do
      stub = stub_request(:get, "#{base_url}/tasks/tasks/TKT-1")
             .with(
               headers: {
                 'Authorization' => "Bearer #{api_key}",
                 'Content-Type' => 'application/json',
                 'BU-Connection-Id' => connection_id
               }
             )
             .to_return(
               status: 200,
               body: '{"data":{"id":"TKT-1","title":"Bug fix"}}',
               headers: { 'Content-Type' => 'application/json' }
             )

      result = instance.task('TKT-1')
      expect(result).to eq({ 'data' => { 'id' => 'TKT-1', 'title' => 'Bug fix' } })
      expect(stub).to have_been_requested
    end

    it 'encodes the task id' do
      stub = stub_request(:get, "#{base_url}/tasks/tasks/a%2Fb")
             .to_return(
               status: 200,
               body: '{"data":{}}',
               headers: { 'Content-Type' => 'application/json' }
             )

      instance.task('a/b')
      expect(stub).to have_been_requested
    end

    it 'raises without an id' do
      expect { instance.task(nil) }
        .to raise_error(ArgumentError, 'task_id is required to fetch a task.')
    end

    it 'raises error on 404' do
      stub_request(:get, "#{base_url}/tasks/tasks/TKT-1")
        .to_return(status: 404, body: '{"error":"Not Found"}')

      expect { instance.task('TKT-1') }.to raise_error(Faraday::ResourceNotFound)
    end
  end

  describe '#projects' do
    it 'makes a GET request to projects endpoint' do
      stub = stub_request(:get, "#{base_url}/tasks/projects")
             .with(
               headers: {
                 'Authorization' => "Bearer #{api_key}",
                 'Content-Type' => 'application/json',
                 'BU-Connection-Id' => connection_id
               }
             )
             .to_return(
               status: 200,
               body: '{"data":[{"id":"PRJ-1","name":"Roadmap"}]}',
               headers: { 'Content-Type' => 'application/json' }
             )

      result = instance.projects
      expect(result).to eq({ 'data' => [{ 'id' => 'PRJ-1', 'name' => 'Roadmap' }] })
      expect(stub).to have_been_requested
    end

    it 'supports paging parameters' do
      stub = stub_request(:get, "#{base_url}/tasks/projects?after=cursor_1&limit=5")
             .to_return(status: 200, body: '{"data":[]}', headers: { 'Content-Type' => 'application/json' })

      instance.projects(limit: 5, after: 'cursor_1')
      expect(stub).to have_been_requested
    end

    it 'raises error on 401' do
      stub_request(:get, "#{base_url}/tasks/projects")
        .to_return(status: 401, body: '{"error":"Unauthorized"}')

      expect { instance.projects }.to raise_error(Faraday::UnauthorizedError)
    end
  end
end
