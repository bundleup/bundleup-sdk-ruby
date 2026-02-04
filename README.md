# BundleUp Ruby SDK

[![Gem Version](https://badge.fury.io/rb/bundleup-sdk.svg)](https://badge.fury.io/rb/bundleup-sdk)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Official Ruby client library for the [BundleUp](https://bundleup.io) API. Connect to 100+ integrations with a single, unified API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bundleup'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install bundleup
```

## Requirements

- Ruby 2.7 or higher
- Bundler

## Quick Start

```ruby
require 'bundleup'

# Initialize the client with your API key
client = Bundleup::Client.new(ENV['BUNDLEUP_API_KEY'])

# List all connections
connections = client.connections.list
puts connections

# Create a new connection
new_connection = client.connections.create({
  name: 'My Connection',
  integration_id: 'integration_123'
})
```

## Authentication

The BundleUp SDK uses API keys for authentication. You can obtain your API key from the [BundleUp Dashboard](https://app.bundleup.io).

```ruby
# Initialize with API key
client = Bundleup::Client.new('your_api_key_here')

# Or use environment variable (recommended)
client = Bundleup::Client.new(ENV['BUNDLEUP_API_KEY'])
```

**Security Best Practice:** Never commit your API keys to version control. Use environment variables or a secure credential management system.

## Usage

### Connections

Manage your integration connections:

```ruby
# List all connections
connections = client.connections.list

# List with pagination
connections = client.connections.list(limit: 10, page: 1)

# Retrieve a specific connection
connection = client.connections.retrieve('conn_123')

# Create a new connection
connection = client.connections.create({
  name: 'GitHub Connection',
  integration_id: 'int_github'
})

# Update a connection
updated = client.connections.update('conn_123', {
  name: 'Updated GitHub Connection'
})

# Delete a connection
client.connections.delete('conn_123')
```

### Integrations

Work with available integrations:

```ruby
# List all integrations
integrations = client.integrations.list

# Retrieve a specific integration
integration = client.integrations.retrieve('int_123')
```

### Webhooks

Manage webhook subscriptions:

```ruby
# List all webhooks
webhooks = client.webhooks.list

# Create a webhook
webhook = client.webhooks.create({
  url: 'https://example.com/webhook',
  events: ['connection.created', 'connection.deleted']
})

# Retrieve a webhook
webhook = client.webhooks.retrieve('webhook_123')

# Update a webhook
updated = client.webhooks.update('webhook_123', {
  url: 'https://example.com/new-webhook'
})

# Delete a webhook
client.webhooks.delete('webhook_123')
```

### Proxy API

Make direct calls to the underlying integration APIs:

```ruby
# Initialize proxy for a connection
proxy = client.proxy('conn_123')

# Make GET request
users = proxy.get('/api/users')

# Make POST request
new_user = proxy.post('/api/users', {
  name: 'John Doe',
  email: 'john@example.com'
})

# Make PUT request
updated_user = proxy.put('/api/users/123', {
  name: 'Jane Doe'
})

# Make PATCH request
patched_user = proxy.patch('/api/users/123', {
  email: 'jane@example.com'
})

# Make DELETE request
proxy.delete('/api/users/123')
```

### Unify API

Access unified, normalized data across different integrations:

#### Chat (Slack, Discord, Microsoft Teams, etc.)

```ruby
# Get unified API instances for a connection
unify = client.unify('conn_123')

# List channels
channels = unify[:chat].channels(limit: 100)

# List channels with pagination
channels = unify[:chat].channels(limit: 50, cursor: 'next_page_token')

# Include raw response from the integration
channels = unify[:chat].channels(limit: 100, include_raw: true)
```

#### Git (GitHub, GitLab, Bitbucket, etc.)

```ruby
unify = client.unify('conn_123')

# List repositories
repos = unify[:git].repos(limit: 50)

# List pull requests for a repository
pulls = unify[:git].pulls('owner/repo', limit: 20)

# List tags for a repository
tags = unify[:git].tags('owner/repo')

# List releases for a repository
releases = unify[:git].releases('owner/repo', limit: 10)

# Include raw response
repos = unify[:git].repos(include_raw: true)
```

#### Project Management (Jira, Linear, Asana, etc.)

```ruby
unify = client.unify('conn_123')

# List issues
issues = unify[:pm].issues(limit: 100)

# List with pagination
issues = unify[:pm].issues(limit: 50, cursor: 'next_page_token')

# Include raw response
issues = unify[:pm].issues(include_raw: true)
```

## Error Handling

The SDK provides custom exception classes for different error scenarios:

```ruby
begin
  client = Bundleup::Client.new('invalid_key')
  connections = client.connections.list
rescue Bundleup::AuthenticationError => e
  puts "Authentication failed: #{e.message}"
rescue Bundleup::InvalidRequestError => e
  puts "Invalid request: #{e.message}"
rescue Bundleup::APIError => e
  puts "API error: #{e.message}"
rescue Bundleup::Error => e
  puts "General error: #{e.message}"
end
```

### Exception Classes

- `Bundleup::Error` - Base class for all BundleUp errors
- `Bundleup::APIError` - Raised when an API error occurs
- `Bundleup::AuthenticationError` - Raised when authentication fails
- `Bundleup::InvalidRequestError` - Raised when a request is invalid

## Advanced Usage

### Custom Connection Configuration

```ruby
# The SDK uses Faraday under the hood with automatic retries
# Retry logic is configured with:
# - Max retries: 3
# - Initial interval: 0.5 seconds
# - Backoff factor: 2
```

### Pagination

Most list endpoints support pagination:

```ruby
# Using limit and page
connections = client.connections.list(limit: 10, page: 1)

# Using cursor-based pagination (for Unify API)
channels = unify[:chat].channels(limit: 50, cursor: 'next_page_token')
```

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake spec` to run the tests.

To install this gem onto your local machine, run:

```bash
bundle exec rake install
```

To release a new version, update the version number in `lib/bundleup/version.rb`, and then run:

```bash
bundle exec rake release
```

## Testing

Run the test suite:

```bash
bundle exec rspec
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bundleup/bundleup-sdk-ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Support

- Documentation: [https://docs.bundleup.io](https://docs.bundleup.io)
- Email: [support@bundleup.io](mailto:support@bundleup.io)
- GitHub Issues: [https://github.com/bundleup/bundleup-sdk-ruby/issues](https://github.com/bundleup/bundleup-sdk-ruby/issues)

## Code of Conduct

Everyone interacting in the BundleUp project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bundleup/bundleup-sdk-ruby/blob/main/CODE_OF_CONDUCT.md).
