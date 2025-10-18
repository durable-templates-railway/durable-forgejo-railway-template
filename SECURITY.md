# Security Policy

## Reporting a Vulnerability

If you discover a security vulnerability in this Railway template, please report it by emailing:

**security@durableprogramming.com**

Please include:
- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if any)

We will respond to security reports within 48 hours.

## Security Best Practices

When deploying this template:

1. **Admin Account**: Change the default admin password immediately after first login
2. **Database Credentials**: Railway automatically generates secure database credentials. Never commit secrets to version control.
3. **Secret Key**: Railway automatically generates a secure secret key for encryption
4. **Network Access**: Configure Railway's private networking for inter-service communication
5. **Updates**: Keep the Forgejo version updated to receive security patches
6. **SSH Keys**: Use SSH keys for Git operations instead of passwords
7. **2FA**: Enable two-factor authentication for all users
8. **Access Tokens**: Use access tokens with minimal scopes for API access
9. **HTTPS**: Always use HTTPS for accessing Forgejo (Railway provides this by default)
10. **Registration**: Consider disabling public registration for private instances

## Supported Versions

We support the latest version of this template with security updates.

## Disclosure Policy

We practice responsible disclosure and will:
- Acknowledge receipt of vulnerability reports within 48 hours
- Provide a fix timeline within 7 days
- Release security updates as soon as patches are available
- Credit researchers who responsibly disclose vulnerabilities (if desired)
