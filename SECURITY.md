# Security Policy

## Supported Versions

We release patches for security vulnerabilities. Which versions are eligible for receiving such patches depends on the CVSS v3.0 Rating:

| Version | Supported          |
| ------- | ------------------ |
| 0.1.x   | :white_check_mark: |

## Reporting a Vulnerability

Please report (suspected) security vulnerabilities to **[support@bundleup.io](mailto:support@bundleup.io)**. You will receive a response from us within 48 hours. If the issue is confirmed, we will release a patch as soon as possible depending on complexity but historically within a few days.

## Security Best Practices

When using the BundleUp SDK, please follow these security best practices:

1. **API Key Security**
   - Never commit API keys to version control
   - Use environment variables or secure credential management systems
   - Rotate API keys regularly
   - Use different API keys for development and production

2. **Network Security**
   - Always use HTTPS endpoints (which is the default)
   - Verify SSL certificates are valid
   - Use secure network connections when making API calls

3. **Data Handling**
   - Sanitize and validate all user inputs before passing to the SDK
   - Be cautious when logging API responses that may contain sensitive data
   - Follow data retention policies for your organization

4. **Dependencies**
   - Keep the SDK and its dependencies up to date
   - Regularly check for security advisories
   - Use tools like `bundle audit` to check for vulnerable dependencies

## Disclosure Policy

When we receive a security bug report, we will:

1. Confirm the problem and determine affected versions
2. Audit code to find any similar problems
3. Prepare fixes for all supported releases
4. Release new security fix versions as soon as possible

Thank you for helping keep BundleUp and our users safe!
