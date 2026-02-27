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
- [Support](#support)

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
- 🪶 **Lightweight** - Minimal dependencies
- 🛡️ **Error Handling** - Comprehensive error messages and validation
- 📚 **Well Documented** - Extensive documentation and examples
- 🧪 **Tested** - Comprehensive test suite with RSpec

## Examples

Runnable examples are available in the [`examples/`](./examples) directory:

- [`examples/basic_usage.rb`](./examples/basic_usage.rb) - Client setup, connections, integrations, and webhooks
- [`examples/proxy_api.rb`](./examples/proxy_api.rb) - Proxy API GET request with a connection
- [`examples/unify_api.rb`](./examples/unify_api.rb) - Unify Chat, Git, and PM endpoint usage
- [`examples/README.md`](./examples/README.md) - Setup and execution instructions

## Quick Start

Get started with BundleUp in just a few lines of code:

```ruby
require 'bundleup'

# Initialize the client
client = Bundleup::Client.new(ENV['BUNDLEUP_API_KEY'])

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
client = Bundleup::Client.new('your_api_key_here')

# Or use environment variable (recommended)
client = Bundleup::Client.new(ENV['BUNDLEUP_API_KEY'])
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
BUNDLEUP_API_KEY=bu_live_1234567890abcdefghijklmnopqrstuvwxyz
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

client = Bundleup::Client.new(ENV['BUNDLEUP_API_KEY'])
```

**For Rails applications:**

```ruby
# config/initializers/bundleup.rb
BUNDLEUP_CLIENT = Bundleup::Client.new(ENV['BUNDLEUP_API_KEY'])
```

## Core Concepts

### Platform API

The **Platform API** provides access to core BundleUp features like managing connections and integrations. Use this API to list, retrieve, and delete connections, as well as discover available integrations.

### Proxy API

The **Proxy API** allows you to make direct HTTP requests to the underlying integration's API through BundleUp. This is useful when you need access to integration-specific features not covered by the Unify API.

### Unify API

The **Unify API** provides a standardized, normalized interface across different integrations. For example, you can fetch chat channels from Slack, Discord, or Microsoft Teams using the same API call.

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
    signature = request.headers['Bundleup-Signature']
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

#### Project Management API

The PM API provides a unified interface for project management platforms like Jira, Linear, and Asana.

##### List Issues

```ruby
result = unify.pm.issues(
  limit: 100,
  after: nil,
  include_raw: false
)

puts "Issues: #{result['data']}"
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
open_issues = result['data'].select { |issue| issue['status'] == 'open' }
sorted_by_date = result['data'].sort_by { |issue| Time.parse(issue['created_at']) }.reverse
```

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
│   ├── proxy.rb             # Proxy API implementation
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
│       └── pm.rb            # PM Unify API
spec/                        # Test files
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

## Support

Need help? We're here for you!

### Documentation

- **Official Docs**: [https://docs.bundleup.io](https://docs.bundleup.io)
- **API Reference**: [https://docs.bundleup.io/api](https://docs.bundleup.io/api)
- **SDK Guides**: [https://docs.bundleup.io/sdk/ruby](https://docs.bundleup.io/sdk/ruby)

### Community

- **Discord**: [https://discord.gg/bundleup](https://discord.gg/bundleup)
- **GitHub Discussions**: [https://github.com/bundleup/bundleup-sdk-ruby/discussions](https://github.com/bundleup/bundleup-sdk-ruby/discussions)
- **Stack Overflow**: Tag your questions with `bundleup`

### Direct Support

- **Email**: [support@bundleup.io](mailto:support@bundleup.io)
- **GitHub Issues**: [https://github.com/bundleup/bundleup-sdk-ruby/issues](https://github.com/bundleup/bundleup-sdk-ruby/issues)
- **Twitter**: [@bundleup_io](https://twitter.com/bundleup_io)

### Enterprise Support

For enterprise customers, we offer:

- Priority support with SLA
- Dedicated support channel
- Architecture consultation
- Custom integration assistance

Contact [enterprise@bundleup.io](mailto:enterprise@bundleup.io) for more information.

## Code of Conduct

Everyone interacting in the BundleUp project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bundleup/bundleup-sdk-ruby/blob/main/CODE_OF_CONDUCT).

---

Made with ❤️ by the [BundleUp](https://bundleup.io) team
