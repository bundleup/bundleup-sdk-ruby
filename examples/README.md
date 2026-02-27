# BundleUp Ruby SDK Examples

This folder contains runnable scripts that show common SDK workflows.

## Prerequisites

- Ruby 2.7+
- `bundle install` run from `bundleup-sdk-ruby/`
- `BUNDLEUP_API_KEY` set in your environment

For examples that use a connected integration, also set:

- `BUNDLEUP_CONNECTION_ID`

## Run an Example

From `bundleup-sdk-ruby/`:

```bash
ruby examples/basic_usage.rb
ruby examples/proxy_api.rb
ruby examples/unify_api.rb
```

## Scripts

- `basic_usage.rb` — initialize the SDK and list connections, integrations, and webhooks
- `proxy_api.rb` — send a GET request through the Proxy API
- `unify_api.rb` — call Unify Chat, Git, and PM endpoints
