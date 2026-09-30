# BundleUp Ruby SDK

[![Gem Version](https://badge.fury.io/rb/bundleup-sdk.svg)](https://badge.fury.io/rb/bundleup-sdk)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Official Ruby SDK for the [BundleUp](https://bundleup.io) API. Connect to 100+ integrations with a single, unified API. Build once, integrate everywhere.

## Table of Contents

- [Installation](#installation)
- [Requirements](#requirements)
- [Features](#features)
- [Examples](#examples)
- [Quick Start](#quick-start)
- [Authentication](#authentication)
- [Core Concepts](#core-concepts)
- [API Reference](#api-reference)
  - [Connections](#connections)
  - [Integrations](#integrations)
  - [Webhooks](#webhooks)
  - [Proxy API](#proxy-api)
  - [Unify API](#unify-api)
- [Error Handling](#error-handling)
- [Development](#development)
- [Contributing](#contributing)
- [License](#license)

## Installation

Install the SDK using Bundler or RubyGems:

**Using Bundler (recommended):**

Add this line to your application's Gemfile:

```ruby
gem 'bundleup-sdk'
```

And then execute:

```bash
bundle install
```

**Using RubyGems:**

```bash
gem install bundleup-sdk
```

## Requirements

- **Ruby**: 2.7.0 or higher
- **Faraday**: ~> 2.0 (automatically installed as a dependency)

### Ruby Compatibility

The BundleUp SDK is tested and supported on:

- Ruby 2.7.x
- Ruby 3.0.x
- Ruby 3.1.x
- Ruby 3.2.x
- Ruby 3.3.x

## Features

- 🚀 **Ruby Idiomatic** - Follows Ruby best practices and conventions
- 📦 **Easy Integration** - Simple, intuitive API design
- ⚡ **HTTP/2 Support** - Built on Faraday for modern HTTP features
- 🔌 **100+ Integrations** - Connect to Slack, GitHub, Jira, Linear, and many more
- 🎯 **Unified API** - Consistent interface across all integrations via Unify API
- 🔑 **Proxy API** - Direct access to underlying integration APIs
- 🤖 **MCP** - Connect agents to a provider's own MCP server or to BundleUp's Unified MCP
- 🪶 **Lightweight** - Minimal dependencies
- 🛡️ **Error Handling** - Comprehensive error messages and validation
- 📚 **Well Documented** - Extensive documentation and examples
- 🧪 **Tested** - Comprehensive test suite with RSpec

## Examples

Runnable examples are available in the [`examples/`](./examples) directory:

- [`examples/basic_usage.rb`](./examples/basic_usage.rb) - Client setup, connections, integrations, and webhooks
- [`examples/proxy_api.rb`](./examples/proxy_api.rb) - Proxy API GET request with a connection
- [`examples/unify_api.rb`](./examples/unify_api.rb) - Unify Chat, Git, PM, Ticketing, Drive, and Calendar endpoint usage
- [`examples/README.md`](./examples/README.md) - Setup and execution instructions

## Quick Start

Get started with BundleUp in just a few lines of code:

```ruby
require 'bundleup'

# Initialize the client
client = BundleUp::Client.new(ENV['BUNDLEUP_API_KEY'])

# List all active connections
connections = client.connections.list
puts "You have #{connections.length} active connections"

# Use the Proxy API to make requests to integrated services
proxy = client.proxy('conn_123')
response = proxy.get('/api/users')
puts "Users: #{response.body}"

# Use the Unify API for standardized data across integrations
unify = client.unify('conn_456')
channels = unify.chat.channels(limit: 10)
puts "Chat channels: #{channels['data']}"
```

## Authentication

The BundleUp SDK uses API keys for authentication. You can obtain your API key from the [BundleUp Dashboard](https://app.bundleup.io).

### Getting Your API Key

1. Sign in to your [BundleUp Dashboard](https://app.bundleup.io)
2. Navigate to **API Keys**
3. Click **Create API Key**
4. Copy your API key and store it securely

### Initializing the SDK

```ruby
require 'bundleup'

# Initialize with API key
client = BundleUp::Client.new('your_api_key_here')

# Or use environment variable (recommended)
client = BundleUp::Client.new(ENV['BUNDLEUP_API_KEY'])
```

### Security Best Practices

- ✅ **DO** store API keys in environment variables
- ✅ **DO** use a secrets management service in production
- ✅ **DO** rotate API keys regularly
- ❌ **DON'T** commit API keys to version control
- ❌ **DON'T** hardcode API keys in your source code
- ❌ **DON'T** share API keys in public channels

**Example `.env` file:**

```bash
BUNDLEUP_API_KEY=Zw7Lt7JacsDyMCEpnZdGptgnJaOdMzFVH9QtIthnL5RviYP5WeH6e9FWP2HzEO
```

**Loading environment variables (using dotenv):**

Add to your Gemfile:

```ruby
gem 'dotenv'
```

Then in your application:

```ruby
require 'dotenv/load'
require 'bundleup'

client = BundleUp::Client.new(ENV['BUNDLEUP_API_KEY'])
```

**For Rails applications:**

```ruby
# config/initializers/bundleup.rb
BUNDLEUP_CLIENT = BundleUp::Client.new(ENV['BUNDLEUP_API_KEY'])
```

## Core Concepts

### Auth API

The **Auth API** runs the hosted authorization flow: build the URL that sends a user to connect an integration, then exchange the one-time `code` from the redirect for a `connection_id`. See [Authorization Flow](https://docs.bundleup.io/authorization-flow).

### Platform API

The **Platform API** provides access to core BundleUp features like managing connections and integrations. Use this API to list, retrieve, and delete connections, as well as discover available integrations.

### Proxy API

The **Proxy API** allows you to make direct HTTP requests to the underlying integration's API through BundleUp. This is useful when you need access to integration-specific features not covered by the Unify API.

### Unify API

The **Unify API** provides a standardized, normalized interface across different integrations. For example, you can fetch chat channels from Slack, Discord, or Microsoft Teams using the same API call.

### MCP API

The **MCP API** reaches a provider's own MCP server using a connection's stored credentials. Tools are defined by the provider, not by BundleUp. Because the connection is chosen per client, one agent can serve many end users without ever handling a token.

## API Reference

### Connections

Manage your integration connections.

#### List Connections

Retrieve a list of all connections in your account.

```ruby
connections = client.connections.list
```

**With query parameters:**

```ruby
connections = client.connections.list(
  integration_id: 'int_slack',
  limit: 50,
  offset: 0,
  external_id: 'user_123'
)
```

**Query Parameters:**

- `integration_id` (String): Filter by integration ID
- `integration_identifier` (String): Filter by integration identifier (e.g., 'slack', 'github')
- `external_id` (String): Filter by external user/account ID
- `limit` (Integer): Maximum number of results (default: 50, max: 100)
- `offset` (Integer): Number of results to skip for pagination

**Response:**

```ruby
[
  {
    'id' => 'conn_123abc',
    'external_id' => 'user_456',
    'integration_id' => 'int_slack',
    'is_valid' => true,
    'created_at' => '2024-01-15T10:30:00Z',
    'updated_at' => '2024-01-20T14:22:00Z',
    'refreshed_at' => '2024-01-20T14:22:00Z',
    'expires_at' => '2024-04-20T14:22:00Z'
  },
  # ... more connections
]
```

#### Retrieve a Connection

Get details of a specific connection by ID.

```ruby
connection = client.connections.retrieve('conn_123abc')
```

**Response:**

```ruby
{
  'id' => 'conn_123abc',
  'external_id' => 'user_456',
  'integration_id' => 'int_slack',
  'is_valid' => true,
  'created_at' => '2024-01-15T10:30:00Z',
  'updated_at' => '2024-01-20T14:22:00Z',
  'refreshed_at' => '2024-01-20T14:22:00Z',
  'expires_at' => '2024-04-20T14:22:00Z'
}
```

#### Delete a Connection

Remove a connection from your account.

```ruby
client.connections.delete('conn_123abc')
```

**Note:** Deleting a connection will revoke access to the integration and cannot be undone.

### Integrations

Discover and work with available integrations.

#### List Integrations

Get a list of all available integrations.

```ruby
integrations = client.integrations.list
```

**With query parameters:**

```ruby
integrations = client.integrations.list(
  status: 'active',
  limit: 100,
  offset: 0
)
```

**Query Parameters:**

- `status` (String): Filter by status ('active', 'inactive', 'beta')
- `limit` (Integer): Maximum number of results
- `offset` (Integer): Number of results to skip for pagination

**Response:**

```ruby
[
  {
    'id' => 'int_slack',
    'identifier' => 'slack',
    'name' => 'Slack',
    'category' => 'chat',
    'created_at' => '2023-01-01T00:00:00Z',
    'updated_at' => '2024-01-15T10:00:00Z'
  },
  # ... more integrations
]
```

#### Retrieve an Integration

Get details of a specific integration.

```ruby
integration = client.integrations.retrieve('int_slack')
```

**Response:**

```ruby
{
  'id' => 'int_slack',
  'identifier' => 'slack',
  'name' => 'Slack',
  'category' => 'chat',
  'created_at' => '2023-01-01T00:00:00Z',
  'updated_at' => '2024-01-15T10:00:00Z'
}
```

### Webhooks

Manage webhook subscriptions for real-time event notifications.

#### List Webhooks

Get all registered webhooks.

```ruby
webhooks = client.webhooks.list
```

**With pagination:**

```ruby
webhooks = client.webhooks.list(
  limit: 50,
  offset: 0
)
```

**Response:**

```ruby
[
  {
    'id' => 'webhook_123',
    'name' => 'My Webhook',
    'url' => 'https://example.com/webhook',
    'events' => {
      'connection.created' => true,
      'connection.deleted' => true
    },
    'created_at' => '2024-01-15T10:30:00Z',
    'updated_at' => '2024-01-20T14:22:00Z',
    'last_triggered_at' => '2024-01-20T14:22:00Z'
  }
]
```

#### Create a Webhook

Register a new webhook endpoint.

```ruby
webhook = client.webhooks.create(
  name: 'Connection Events Webhook',
  url: 'https://example.com/webhook',
  events: {
    'connection.created' => true,
    'connection.deleted' => true,
    'connection.updated' => true
  }
)
```

**Webhook Events:**

- `connection.created` - Triggered when a new connection is established
- `connection.deleted` - Triggered when a connection is removed
- `connection.updated` - Triggered when a connection is modified

**Request Body:**

- `name` (String): Friendly name for the webhook
- `url` (String): Your webhook endpoint URL
- `events` (Hash): Events to subscribe to

**Response:**

```ruby
{
  'id' => 'webhook_123',
  'name' => 'Connection Events Webhook',
  'url' => 'https://example.com/webhook',
  'events' => {
    'connection.created' => true,
    'connection.deleted' => true,
    'connection.updated' => true
  },
  'created_at' => '2024-01-15T10:30:00Z',
  'updated_at' => '2024-01-15T10:30:00Z'
}
```

#### Retrieve a Webhook

Get details of a specific webhook.

```ruby
webhook = client.webhooks.retrieve('webhook_123')
```

#### Update a Webhook

Modify an existing webhook.

```ruby
updated = client.webhooks.update('webhook_123',
  name: 'Updated Webhook Name',
  url: 'https://example.com/new-webhook',
  events: {
    'connection.created' => true,
    'connection.deleted' => false
  }
)
```

#### Delete a Webhook

Remove a webhook subscription.

```ruby
client.webhooks.delete('webhook_123')
```

#### Webhook Payload Example

When an event occurs, BundleUp sends a POST request to your webhook URL with the following payload:

```json
{
  "id": "evt_1234567890",
  "type": "connection.created",
  "created_at": "2024-01-15T10:30:00Z",
  "data": {
    "id": "conn_123abc",
    "external_id": "user_456",
    "integration_id": "int_slack",
    "is_valid": true,
    "created_at": "2024-01-15T10:30:00Z"
  }
}
```

#### Webhook Security (Rails Example)

To verify webhook signatures in a Rails application:

```ruby
# app/controllers/webhooks_controller.rb
class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    signature = request.headers['BundleUp-Signature']
    payload = request.body.read

    unless verify_signature(payload, signature)
      render json: { error: 'Invalid signature' }, status: :unauthorized
      return
    end

    event = JSON.parse(payload)
    process_webhook_event(event)

    head :ok
  end

  private

  def verify_signature(payload, signature)
    secret = ENV['BUNDLEUP_WEBHOOK_SECRET']
    computed = OpenSSL::HMAC.hexdigest('SHA256', secret, payload)
    ActiveSupport::SecurityUtils.secure_compare(computed, signature)
  end

  def process_webhook_event(event)
    case event['type']
    when 'connection.created'
      handle_connection_created(event['data'])
    when 'connection.deleted'
      handle_connection_deleted(event['data'])
    # ... more event handlers
    end
  end
end
```

### Auth API

Connect an end user's account and get back a `connection_id`. See [Authorization Flow](https://docs.bundleup.io/authorization-flow) for the full flow.

#### Build the Authorization URL

```ruby
url = client.auth.build_authorization_url(
  client_id: 'your-client-id',
  integration_id: 'github',
  redirect_uri: 'https://app.example.com/callback',
  external_id: 'user_42', # optional
  state: 'random-csrf-token' # optional
)

# Redirect the user to `url`
```

**Parameters:**

- `client_id` (String, required): Your workspace client ID
- `integration_id` (String, required): The integration to connect
- `redirect_uri` (String, required): Must exactly match a redirect URI registered in your dashboard
- `external_id` (String, optional): Your own reference, stored on the connection
- `state` (String, optional): Returned unchanged on the redirect

#### Exchange the Code for a Connection

BundleUp redirects back to `redirect_uri` with a one-time `code`. Exchange it server-side:

```ruby
connection = client.auth.get_connection_from_code(
  code: params[:code],
  redirect_uri: 'https://app.example.com/callback'
)

puts connection['connection_id']
```

**Parameters:**

- `code` (String, required): The `code` query parameter from the redirect
- `redirect_uri` (String, required): The same redirect URI used to build the authorization URL

**Response:**

```ruby
{
  'connection_id' => 'conn_abc123',
  'external_id' => 'user_42',
  'integration_id' => 'github'
}
```

The code expires after 5 minutes and can only be exchanged once. An invalid, expired or reused code raises a `RuntimeError` that includes the API's error body. Missing arguments raise `ArgumentError`.

### Proxy API

Make direct HTTP requests to integration APIs through BundleUp.

#### Creating a Proxy Instance

```ruby
proxy = client.proxy('conn_123abc')
```

#### GET Request

```ruby
response = proxy.get('/api/users')
data = response.body
puts data
```

**With custom headers:**

```ruby
response = proxy.get('/api/users', headers: {
  'X-Custom-Header' => 'value',
  'Accept' => 'application/json'
})
```

#### POST Request

```ruby
response = proxy.post('/api/users', body: {
  name: 'John Doe',
  email: 'john@example.com',
  role: 'developer'
})

new_user = response.body
puts "Created user: #{new_user}"
```

**With custom headers:**

```ruby
response = proxy.post(
  '/api/users',
  body: { name: 'John Doe' },
  headers: {
    'Content-Type' => 'application/json',
    'X-API-Version' => '2.0'
  }
)
```

#### PUT Request

```ruby
response = proxy.put('/api/users/123', body: {
  name: 'Jane Doe',
  email: 'jane@example.com'
})

updated_user = response.body
```

#### PATCH Request

```ruby
response = proxy.patch('/api/users/123', body: {
  email: 'newemail@example.com'
})

partially_updated = response.body
```

#### DELETE Request

```ruby
response = proxy.delete('/api/users/123')

if response.success?
  puts 'User deleted successfully'
end
```

#### Working with Response Objects

The Proxy API returns Faraday response objects:

```ruby
response = proxy.get('/api/users')

# Access response body
data = response.body

# Check status code
puts response.status # => 200

# Check if successful
puts response.success? # => true

# Access headers
puts response.headers['content-type']

# Handle errors
begin
  response = proxy.get('/api/invalid')
rescue Faraday::Error => e
  puts "Request failed: #{e.message}"
end
```

### Unify API

Access unified, normalized data across different integrations with a consistent interface.

#### Creating a Unify Instance

```ruby
unify = client.unify('conn_123abc')
```

#### Chat API

The Chat API provides a unified interface for chat platforms like Slack, Discord, and Microsoft Teams.

##### List Users

Retrieve a list of users from the connected chat platform.

```ruby
result = unify.chat.users(
  limit: 100,
  after: nil,
  include_raw: false
)

puts "Users: #{result['data']}"
puts "Next cursor: #{result['metadata']['next']}"
```

**Parameters:**

- `limit` (Integer, optional): Maximum number of users to return (default: 100, max: 1000)
- `after` (String, optional): Pagination cursor from previous response
- `include_raw` (Boolean, optional): Include raw API response from the integration (default: false)

**Response:**

```ruby
{
  'data' => [
    {
      'id' => 'U1234567890',
      'name' => 'Jane Doe'
    }
  ],
  'metadata' => {
    'next' => 'cursor_abc123'
  }
}
```

##### List Channels

Retrieve a list of channels from the connected chat platform.

```ruby
result = unify.chat.channels(
  limit: 100,
  after: nil,
  include_raw: false
)

puts "Channels: #{result['data']}"
puts "Next cursor: #{result['metadata']['next']}"
```

**Parameters:**

- `limit` (Integer, optional): Maximum number of channels to return (default: 100, max: 1000)
- `after` (String, optional): Pagination cursor from previous response
- `include_raw` (Boolean, optional): Include raw API response from the integration (default: false)

**Response:**

```ruby
{
  'data' => [
    {
      'id' => 'C1234567890',
      'name' => 'general'
    },
    {
      'id' => 'C0987654321',
      'name' => 'engineering'
    }
  ],
  'metadata' => {
    'next' => 'cursor_abc123'  # Use this for pagination
  },
  '_raw' => {  # Only present if include_raw: true
    # Original response from the integration API
  }
}
```

**Pagination example:**

```ruby
all_channels = []
cursor = nil

loop do
  result = unify.chat.channels(limit: 100, after: cursor)
  all_channels.concat(result['data'])
  cursor = result['metadata']['next']
  break if cursor.nil?
end

puts "Fetched #{all_channels.length} total channels"
```

##### List Messages

Messages in one channel, newest first. `author.name` is nil on Slack, which returns only a user id on a message.

```ruby
result = unify.chat.messages('C123', limit: 100, after: nil, include_raw: false)

puts "Messages: #{result['data']}"
```

**Response:**

```ruby
{
  'data' => [
    {
      'id' => '1755712345.123456',
      'text' => 'Deploy finished',
      'author' => { 'id' => 'U024BE7LH', 'name' => nil },
      'created_at' => '2026-08-20T18:32:25.123Z',
      'thread_id' => nil
    }
  ],
  'metadata' => {
    'next' => 'cursor_def456'
  }
}
```

##### Send Message

Send a message to a channel on the connected chat platform.

```ruby
result = unify.chat.message('C1234567890', 'Hello from BundleUp! :wave:')

puts "Message sent: #{result['data']}"
```

**Parameters:**

- `channel_id` (String, required): The ID of the channel to send the message to
- `text` (String, required): Markdown-formatted message text

**Response:**

```ruby
{
  'data' => {
    # Raw response data from the chat provider
  }
}
```

#### Git API

The Git API provides a unified interface for version control platforms like GitHub, GitLab, and Bitbucket.

##### List Repositories

```ruby
result = unify.git.repos(
  limit: 50,
  after: nil,
  include_raw: false
)

puts "Repositories: #{result['data']}"
```

**Response:**

```ruby
{
  'data' => [
    {
      'id' => '123456',
      'name' => 'my-awesome-project',
      'full_name' => 'organization/my-awesome-project',
      'description' => 'An awesome project',
      'url' => 'https://github.com/organization/my-awesome-project',
      'created_at' => '2023-01-15T10:30:00Z',
      'updated_at' => '2024-01-20T14:22:00Z',
      'pushed_at' => '2024-01-20T14:22:00Z'
    }
  ],
  'metadata' => {
    'next' => 'cursor_xyz789'
  }
}
```

##### List Pull Requests

```ruby
result = unify.git.pulls('organization/repo-name',
  limit: 20,
  after: nil,
  include_raw: false
)

puts "Pull Requests: #{result['data']}"
```

**Parameters:**

- `repo_name` (String, required): Repository name in the format 'owner/repo'
- `limit` (Integer, optional): Maximum number of PRs to return
- `after` (String, optional): Pagination cursor
- `include_raw` (Boolean, optional): Include raw API response

**Response:**

```ruby
{
  'data' => [
    {
      'id' => '12345',
      'number' => 42,
      'title' => 'Add new feature',
      'description' => 'This PR adds an awesome new feature',
      'draft' => false,
      'state' => 'open',
      'url' => 'https://github.com/org/repo/pull/42',
      'user' => 'john-doe',
      'created_at' => '2024-01-15T10:30:00Z',
      'updated_at' => '2024-01-20T14:22:00Z',
      'merged_at' => nil
    }
  ],
  'metadata' => {
    'next' => nil
  }
}
```

##### List Issues

```ruby
result = unify.git.issues('organization/repo-name', limit: 20)

puts "Issues: #{result['data']}"
```

**Response:**

```ruby
{
  'data' => [
    {
      'id' => 67890,
      'number' => 17,
      'title' => 'Timestamps drift on retry',
      'description' => 'Retried requests report the first attempt time',
      'state' => 'open',
      'url' => 'https://github.com/org/repo/issues/17',
      'user' => 'john-doe',
      'created_at' => '2024-01-15T10:30:00Z',
      'updated_at' => '2024-01-20T14:22:00Z',
      'closed_at' => nil
    }
  ],
  'metadata' => {
    'next' => nil
  }
}
```

##### List Tags

```ruby
result = unify.git.tags('organization/repo-name', limit: 50)

puts "Tags: #{result['data']}"
```

**Response:**

```ruby
{
  'data' => [
    {
      'name' => 'v1.0.0',
      'commit_sha' => 'abc123def456'
    },
    {
      'name' => 'v0.9.0',
      'commit_sha' => 'def456ghi789'
    }
  ],
  'metadata' => {
    'next' => nil
  }
}
```

##### List Releases

```ruby
result = unify.git.releases('organization/repo-name', limit: 10)

puts "Releases: #{result['data']}"
```

**Response:**

```ruby
{
  'data' => [
    {
      'id' => '54321',
      'name' => 'Version 1.0.0',
      'tag_name' => 'v1.0.0',
      'description' => 'Initial release with all the features',
      'prerelease' => false,
      'url' => 'https://github.com/org/repo/releases/tag/v1.0.0',
      'created_at' => '2024-01-15T10:30:00Z',
      'released_at' => '2024-01-15T10:30:00Z'
    }
  ],
  'metadata' => {
    'next' => nil
  }
}
```

##### List Branches

```ruby
result = unify.git.branches('organization/repo-name', limit: 50)

puts "Branches: #{result['data']}"
```

**Response:**

```ruby
{
  'data' => [
    {
      'name' => 'main',
      'commit_sha' => 'abc123def456',
      'protected' => true
    }
  ],
  'metadata' => {
    'next' => nil
  }
}
```

##### List Commits

```ruby
result = unify.git.commits('organization/repo-name', branch: 'main', limit: 20)

puts "Commits: #{result['data']}"
```

`branch` is optional and accepts a branch name, tag or commit SHA. When it is omitted the
provider's default branch is used.

**Response:**

```ruby
{
  'data' => [
    {
      'sha' => 'abc123def4567890abc123def4567890abc123de',
      'message' => 'Add commits endpoint',
      'url' => 'https://github.com/org/repo/commit/abc123def4567890abc123def4567890abc123de',
      'author' => 'Jane Doe',
      'author_email' => 'jane@example.com',
      'committed_at' => '2024-01-15T10:30:00Z'
    }
  ],
  'metadata' => {
    'next' => nil
  }
}
```

#### Ticketing API

The Ticketing API provides a unified interface for ticketing and project management platforms like Jira, Linear, and Asana.

##### List Tickets

```ruby
result = unify.ticketing.tickets(
  limit: 100,
  after: nil,
  include_raw: false
)

puts "Tickets: #{result['data']}"
```

**Response:**

```ruby
{
  'data' => [
    {
      'id' => 'PROJ-123',
      'url' => 'https://jira.example.com/browse/PROJ-123',
      'title' => 'Fix login bug',
      'status' => 'in_progress',
      'description' => 'Users are unable to log in',
      'created_at' => '2024-01-15T10:30:00Z',
      'updated_at' => '2024-01-20T14:22:00Z'
    }
  ],
  'metadata' => {
    'next' => 'cursor_def456'
  }
}
```

**Filtering and sorting:**

```ruby
open_tickets = result['data'].select { |ticket| ticket['status'] == 'open' }
sorted_by_date = result['data'].sort_by { |ticket| Time.parse(ticket['created_at']) }.reverse
```

##### Get a Ticket

Fetch one ticket by ID. Not supported by Basecamp, whose API only serves a to-do underneath its project.

```ruby
result = unify.ticketing.ticket('PROJ-123')

puts "Ticket: #{result['data']}"
```

**Response:**

```ruby
{
  'data' => {
    'id' => 'PROJ-123',
    'url' => 'https://jira.example.com/browse/PROJ-123',
    'title' => 'Fix login bug',
    'status' => 'in_progress',
    'description' => 'Users are unable to log in',
    'created_at' => '2024-01-15T10:30:00Z',
    'updated_at' => '2024-01-20T14:22:00Z'
  }
}
```

A single resource carries no pagination, so there is no `metadata` on this response.

##### List Projects

```ruby
result = unify.ticketing.projects(
  limit: 100,
  after: nil,
  include_raw: false
)

puts "Projects: #{result['data']}"
```

**Response:**

```ruby
{
  'data' => [
    {
      'id' => '10001',
      'name' => 'Website Redesign',
      'status' => 'active',
      'url' => 'https://jira.example.com/browse/PROJ',
      'description' => 'All the work for the new marketing site',
      'created_at' => '2024-01-15T10:30:00Z',
      'updated_at' => '2024-01-20T14:22:00Z'
    }
  ],
  'metadata' => {
    'next' => 'cursor_def456'
  }
}
```

**Note:** Not every platform returns every field. Jira does not expose creation or update timestamps for projects, so `created_at` and `updated_at` are `nil` for Jira connections, and `status` is only set when Jira reports whether the project is archived.

#### CRM API

The CRM API provides a unified interface for CRM platforms like Attio, HubSpot, PipeDrive, Salesforce and Zoho.

##### List Companies

```ruby
result = unify.crm.companies(
  limit: 100,
  after: nil,
  include_raw: false
)

puts "Companies: #{result['data']}"
```

**Response:**

```ruby
{
  'data' => [
    {
      'id' => '12345',
      'name' => 'Acme Inc.',
      'website' => 'https://acme.example.com'
    }
  ],
  'metadata' => {
    'next' => nil
  }
}
```

##### List Contacts

```ruby
result = unify.crm.contacts(
  limit: 100,
  after: nil,
  include_raw: false
)

puts "Contacts: #{result['data']}"
```

**Response:**

```ruby
{
  'data' => [
    {
      'id' => '67890',
      'name' => 'Jane Doe',
      'email' => 'jane@acme.example.com'
    }
  ],
  'metadata' => {
    'next' => nil
  }
}
```

#### Drive API

The Drive API provides a unified interface for file storage platforms like Google Drive, OneDrive, Box, Dropbox and Microsoft SharePoint.

##### List Files

```ruby
result = unify.drive.files(
  limit: 100,
  after: nil,
  include_raw: false
)

puts "Files: #{result['data']}"
```

**Response:**

```ruby
{
  'data' => [
    {
      'id' => 'file_123',
      'name' => 'quarterly-report.pdf',
      'mime_type' => 'application/pdf',
      'size' => 204800,
      'created_at' => '2024-01-15T10:30:00Z',
      'updated_at' => '2024-01-20T14:22:00Z',
      'url' => 'https://drive.example.com/file_123',
      'is_folder' => false
    }
  ],
  'metadata' => {
    'next' => nil
  }
}
```

#### Calendar API

The Calendar API provides a unified interface for calendar and scheduling platforms like Google Calendar, Outlook, Calendly and Zoom.

##### List Events

`starts_after` and `starts_before` are required — the endpoint refuses an unbounded listing.

```ruby
result = unify.calendar.events(
  starts_after: '2026-09-01T00:00:00Z',
  starts_before: '2026-09-08T00:00:00Z',
  limit: 100,
  after: nil,
  include_raw: false
)

puts "Events: #{result['data']}"
```

**Response:**

```ruby
{
  'data' => [
    {
      'id' => 'evt_123',
      'title' => 'Design review',
      'description' => 'Walk through the new onboarding flow',
      'start_date' => '2026-09-01T15:00:00Z',
      'end_date' => '2026-09-01T16:00:00Z',
      'status' => 'confirmed',
      'url' => 'https://calendar.google.com/event?eid=...'
    }
  ],
  'metadata' => {
    'next' => nil
  }
}
```

Recurring events are expanded into their occurrences. All-day events carry a `YYYY-MM-DD` date rather than a timestamp. Attendees, conferencing links and organizers are available through `include_raw` or the Proxy API.

### MCP API

Reach a provider's own MCP server using a connection's credentials. BundleUp injects and refreshes the access token, so the connection ID is the only thing your agent needs to know about a user.

Supported for providers that run a first-party MCP server — see the [integrations page](https://www.bundleup.io/integrations). Others return an `mcp_not_supported` error.

`post` and `delete` are transport only, like the Proxy API — responses come back untouched as `Faraday::Response` objects. `connect` layers a managed session on top when you would rather not drive the protocol yourself.

#### Creating an MCP Client

```ruby
mcp = client.mcp('conn_123abc')
```

#### Managed Sessions

`connect` returns a client that handles the handshake, session ID and response decoding, and exposes what the provider offers.

```ruby
mcp = client.mcp('conn_123abc').connect

tools = mcp.list_tools
result = mcp.call_tool('create_issue', { title: 'Login broken' })

mcp.close
```

Resources and prompts follow the same shape:

```ruby
resources = mcp.list_resources
contents = mcp.read_resource('file:///readme.md')

prompts = mcp.list_prompts
messages = mcp.get_prompt('summarize', { id: '123' })
```

Anything else in the protocol:

```ruby
mcp.request('logging/setLevel', { level: 'debug' })
```

The handshake runs lazily on the first call and once per client, list methods follow `nextCursor` to the end, and `text/event-stream` responses are decoded for you. Results are hashes with string keys. Errors raise a `RuntimeError` with the provider's message, or BundleUp's with its code appended — `Missing or invalid connection ID (connection_invalid)`.

Call `close` when you are done to end the session upstream.

#### Model-Hosted MCP

OpenAI and Anthropic can connect to an MCP server themselves, with no tool mapping or dispatch loop on your side. Both accept only a single credential and no custom headers, so `hosted` returns the server URL alongside the API key and connection joined into one bearer.

```ruby
hosted = client.mcp('conn_123abc').hosted

response = openai.responses.create(
  model: 'gpt-4o',
  input: 'What issues are assigned to me?',
  tools: [
    {
      type: 'mcp',
      server_label: 'linear',
      server_url: hosted[:url],
      authorization: hosted[:token],
      require_approval: 'never'
    }
  ]
)
```

Anthropic's connector takes the same pair as `url` and `authorization_token`. `client.unify('conn_123abc').mcp.hosted` returns them for Unified MCP.

`server_url` must be exactly the URL `hosted` returns — the proxy rebuilds the upstream URL from the provider's own base, so any path or query you append is ignored rather than rejected.

This sends your API key to the model provider, whose servers make the request. Use an MCP client in your own backend if that is not acceptable.

#### Using an MCP Client Library

`transport` returns the URL and headers if you would rather use an existing MCP client. Pass them to any client that supports the streamable HTTP transport.

```ruby
transport = client.mcp('conn_123abc').transport

transport[:url]     # => "https://mcp.bundleup.io"
transport[:headers] # => { "Authorization" => "Bearer ...", "BU-Connection-Id" => "conn_123abc", ... }
```

#### Sending JSON-RPC Directly

MCP requires an `initialize` handshake before any other method. The session ID comes back on that first response and must be sent on every call after it.

```ruby
mcp = client.mcp('conn_123abc')

# 1. Handshake
init = mcp.post({
  jsonrpc: '2.0',
  id: 1,
  method: 'initialize',
  params: {
    protocolVersion: '2025-06-18',
    capabilities: {},
    clientInfo: { name: 'my-agent', version: '1.0.0' }
  }
})

session_id = init.headers['mcp-session-id']
session = session_id ? { 'Mcp-Session-Id' => session_id } : {}

# 2. Confirm the handshake (a notification — no id, no response body)
mcp.post({ jsonrpc: '2.0', method: 'notifications/initialized' }, headers: session)

# 3. List tools
response = mcp.post({ jsonrpc: '2.0', id: 2, method: 'tools/list' }, headers: session)
result = parse(response)['result']

puts result['tools']
```

Providers may answer with `text/event-stream` rather than JSON, so responses need unwrapping either way:

```ruby
require 'json'

def parse(response)
  return JSON.parse(response.body) unless response.headers['content-type'].to_s.include?('text/event-stream')

  data = response.body.lines
                 .select { |line| line.start_with?('data:') }
                 .map { |line| line[5..].strip }
                 .join("\n")

  JSON.parse(data)
end
```

Tool lists can be paginated. If `result['nextCursor']` is set, call `tools/list` again with `params: { cursor: result['nextCursor'] }` until it comes back empty.

Calling a tool follows the same shape:

```ruby
response = mcp.post({
  jsonrpc: '2.0',
  id: 3,
  method: 'tools/call',
  params: { name: 'create_issue', arguments: { title: 'Login broken' } }
}, headers: session)
```

#### Sessions

MCP sessions live on the provider's server — BundleUp holds no session state. Close one when you are done:

```ruby
mcp.delete(headers: { 'Mcp-Session-Id' => session_id })
```

#### Errors

BundleUp rejects a request before it reaches the provider by returning an HTTP error with a JSON body — the response is passed straight through, so check `response.success?` yourself.

```ruby
response = mcp.post(body)

unless response.success?
  error = JSON.parse(response.body)
  # connection_invalid, connection_refresh_failed, mcp_not_supported, rate_limit
  warn "#{error['code']}: #{error['message']}"
end
```

Every JSON-RPC message counts toward the rate limit of 100 requests per 60 seconds, per connection — including the `initialize` handshake.

#### Merging Several Connections

An agent often needs more than one provider for the same end user. There is no merge helper in the SDK — how tools are namespaced, filtered and recovered from differs enough per agent that it is better written where you can see it:

```ruby
clients = {
  'slack' => client.mcp(user.slack_connection).connect,
  'linear' => client.mcp(user.linear_connection).connect,
  'crm' => client.unify(user.hubspot_connection).mcp
}

# One namespaced list: slack__send_message, linear__create_issue, …
tools = clients.flat_map do |label, mcp|
  mcp.list_tools.map { |tool| tool.merge('name' => "#{label}__#{tool['name']}") }
end

# Route a call back to the client that owns it
call = lambda do |name, args|
  label, tool_name = name.split('__', 2)
  clients.fetch(label).call_tool(tool_name, args)
end
```

Anything that exposes `list_tools` and `call_tool(name, args)` fits the same shape, so an internal tool layer of your own can sit in that map alongside BundleUp connections.

Two things worth handling that the sketch above skips. **Filter before you hand the list to a model** — three providers is easily sixty tools, and accuracy drops as that list grows, so select the ones the agent actually needs rather than passing everything. And decide what an unreachable provider should do: as written, one failing `list_tools` raises and fails the whole list, while a `rescue` per client lets the others through.

#### Unified MCP

BundleUp's normalized tools instead of the provider's, on the same protocol. Tools only — Unified MCP exposes no resources or prompts.

```ruby
mcp = client.unify('conn_123abc').mcp

tools = mcp.list_tools
result = mcp.call_tool('send_message', { text: 'Deploy finished' })
```

`unify.mcp` is memoized per Unify client, so the handshake runs once no matter how often you call it. The server itself is stateless and POST-only, so there is no session to close.

## Error Handling

The SDK raises exceptions for errors. Always wrap SDK calls in rescue blocks for proper error handling.

```ruby
begin
  connections = client.connections.list
rescue StandardError => e
  puts "Failed to fetch connections: #{e.message}"
end
```

## Development

### Setting Up Development Environment

```bash
# Clone the repository
git clone https://github.com/bundleup/bundleup-sdk-ruby.git
cd bundleup-sdk-ruby

# Install dependencies
bundle install

# Run tests
bundle exec rspec

# Run RuboCop
bundle exec rubocop

# Run tests with coverage
COVERAGE=true bundle exec rspec
```

### Project Structure

```
lib/
├── bundleup.rb              # Main entry point
├── bundleup/
│   ├── client.rb            # Main client class
│   ├── auth.rb              # Auth API (authorization URL + code exchange)
│   ├── proxy.rb             # Proxy API implementation
│   ├── mcp.rb               # MCP API (transport + managed sessions)
│   ├── unify.rb             # Unify API client wrapper
│   ├── version.rb           # Gem version
│   ├── resources/
│   │   ├── base.rb          # Base resource class
│   │   ├── connection.rb    # Connections API
│   │   ├── integration.rb   # Integrations API
│   │   └── webhook.rb       # Webhooks API
│   └── unify/
│       ├── base.rb          # Base Unify class
│       ├── chat.rb          # Chat Unify API
│       ├── git.rb           # Git Unify API
│       ├── ticketing.rb     # Ticketing Unify API
│       ├── crm.rb           # CRM Unify API
│       ├── drive.rb         # Drive Unify API
│       └── calendar.rb      # Calendar Unify API
sig/                         # RBS type signatures (mirrors lib/)
spec/                        # Test files
```

### Type Signatures

The gem ships [RBS](https://github.com/ruby/rbs) signatures for the Unify API under `sig/bundleup/unify/`. They're optional at runtime (deleting `sig/` doesn't change behavior) but give editors and `rbs` itself static types for `unify.chat.channels`, `unify.git.repos`, and so on.

```bash
# Validate the signature files
bundle exec rake sig
```

### Running Tests

```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/bundleup/proxy_spec.rb

# Run with documentation format
bundle exec rspec --format documentation

# Run with coverage
COVERAGE=true bundle exec rspec
```

### Building the Gem

```bash
# Build the gem
gem build bundleup-sdk.gemspec

# Install locally
gem install bundleup-sdk-0.1.0.gem

# Push to RubyGems (requires credentials)
gem push bundleup-sdk-0.1.0.gem
```

### Linting

```bash
# Run RuboCop
bundle exec rubocop

# Auto-correct offenses
bundle exec rubocop -a

# Check specific file
bundle exec rubocop lib/bundleup/client.rb
```

## Contributing

We welcome contributions to the BundleUp Ruby SDK! Here's how you can help:

### Reporting Bugs

1. Check if the bug has already been reported in [GitHub Issues](https://github.com/bundleup/bundleup-sdk-ruby/issues)
2. If not, create a new issue with:
   - Clear title and description
   - Steps to reproduce
   - Expected vs actual behavior
   - Gem version and Ruby version

### Suggesting Features

1. Open a new issue with the "feature request" label
2. Describe the feature and its use case
3. Explain why this feature would be useful

### Pull Requests

1. Fork the repository
2. Create a new branch: `git checkout -b feature/my-new-feature`
3. Make your changes
4. Write or update tests
5. Ensure all tests pass: `bundle exec rspec`
6. Run RuboCop: `bundle exec rubocop`
7. Commit your changes: `git commit -am 'Add new feature'`
8. Push to the branch: `git push origin feature/my-new-feature`
9. Submit a pull request

### Development Guidelines

- Follow Ruby style guide and RuboCop rules
- Add RSpec tests for new features
- Update documentation for API changes
- Keep commits focused and atomic
- Write clear commit messages
- Maintain backward compatibility when possible

## License

This gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

```
Copyright (c) 2026 BundleUp

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## Code of Conduct

Everyone interacting in the BundleUp project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bundleup/bundleup-sdk-ruby/blob/main/CODE_OF_CONDUCT).

---

Made with ❤️ by the [BundleUp](https://bundleup.io) team
