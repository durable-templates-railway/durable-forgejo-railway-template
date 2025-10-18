# Forgejo Self-Hosted

Deploy Forgejo, the lightweight self-hosted Git service, on Railway with one click. This template provides a production-ready deployment of Forgejo for Git repository hosting and collaboration.

Forgejo is a painless self-hosted Git service that's a community-driven fork of Gitea, providing Git hosting, code review, team collaboration, and package registry in a lightweight, fast application.

## Features

- **Git Repository Hosting**: Full-featured Git hosting with web-based interface
- **Lightweight and Fast**: Written in Go, minimal resource requirements
- **Issue Tracking**: Simple and effective issue management
- **Pull Requests**: Code review with inline comments
- **Wiki**: Built-in wiki for documentation
- **Webhooks**: Integration with external services
- **Built-in CI/CD**: Forgejo Actions (GitHub Actions compatible)
- **Package Registry**: Support for multiple package types
- **Self-hosted**: Complete control over your code and data

## Architecture

This Railway template deploys Forgejo as a multi-service application with the following components:

### Core Services
- **Forgejo** (`forgejo/`): All-in-one Git service
- **PostgreSQL** (`postgresql/`): Primary database for application data

### Service Dependencies
- Forgejo depends on PostgreSQL for data storage
- All services communicate via Railway's private networking

### Directory Structure
```
.
├── forgejo/
│   ├── Dockerfile          # Custom Forgejo image configuration
│   ├── railway.json        # Forgejo service configuration
│   └── railway.toml        # Forgejo deployment settings
├── postgresql/
│   ├── railway.json        # PostgreSQL service configuration
│   └── railway.toml        # PostgreSQL deployment settings
└── README.md
```

This architecture provides a complete, lightweight Git hosting solution suitable for individuals and teams.

## Quick Start

Deploy Forgejo to Railway in minutes:

1. Click the "Deploy on Railway" button
2. Railway will automatically generate all required secrets
3. Wait for deployment completion
4. Access your Forgejo instance at the provided Railway URL
5. Complete the initial setup wizard

## Installation

### Railway (Recommended)

1. Click "Deploy on Railway" to create a new Railway project
2. Railway will create two services from the `forgejo/` and `postgresql/` directories
3. Set the following environment variables for the Forgejo service:
   - `FORGEJO__server__DOMAIN`: `${{RAILWAY_PUBLIC_DOMAIN}}`
   - `FORGEJO__server__ROOT_URL`: `https://${{RAILWAY_PUBLIC_DOMAIN}}/`
   - `FORGEJO__server__HTTP_PORT`: `${{PORT}}`
   - `FORGEJO__database__DB_TYPE`: `postgres`
   - `FORGEJO__database__HOST`: `${{postgresql.RAILWAY_PRIVATE_DOMAIN}}:5432`
   - `FORGEJO__database__NAME`: `forgejo`
   - `FORGEJO__database__USER`: `forgejo`
   - `FORGEJO__database__PASSWD`: `${{postgresql.POSTGRES_PASSWORD}}`
   - `FORGEJO__security__INSTALL_LOCK`: `true`
   - `FORGEJO__security__SECRET_KEY`: Generate a random 32-character hex string
   - `USER_UID`: `1000`
   - `USER_GID`: `1000`
4. Set the following environment variables for the PostgreSQL service:
   - `POSTGRES_USER`: `forgejo`
   - `POSTGRES_PASSWORD`: Generate a random password
   - `POSTGRES_DB`: `forgejo`
5. Wait for deployment completion
6. Access your Forgejo instance at the Railway-provided domain

### Docker

For local development or custom deployments:

1. Clone this repository:
   ```bash
   git clone https://github.com/durable-templates-railway/durable-forgejo-railway-template.git
   cd durable-forgejo-railway-template
   ```

2. Set environment variables:
   ```bash
   export POSTGRES_PASSWORD=$(openssl rand -hex 16)
   export FORGEJO_SECRET_KEY=$(openssl rand -hex 32)
   ```

3. Start with Docker Compose:
   ```bash
   docker-compose up -d
   ```

4. Access the UI at `http://localhost:3000`

### Standalone Binary

Download and run Forgejo directly:

```bash
# Download latest Forgejo binary
curl -L -o forgejo https://codeberg.org/forgejo/forgejo/releases/latest/download/forgejo-13.0.1-linux-amd64
chmod +x forgejo

# Set basic configuration
export FORGEJO__security__SECRET_KEY=$(openssl rand -hex 32)
export FORGEJO__database__DB_TYPE=sqlite3

# Start Forgejo
./forgejo web
```

### From Source

Build Forgejo from source:

```bash
# Install Go 1.21+
git clone https://codeberg.org/forgejo/forgejo.git
cd forgejo
make build
./forgejo web
```

## Usage

### Basic Usage

After deployment:
1. Access Forgejo through the Railway-provided domain
2. Complete the initial setup wizard
3. Create your first repository or import existing ones
4. Invite team members and start collaborating

### Creating a Repository

```bash
# Using Forgejo CLI
forgejo admin repo create --name my-project --owner username

# Using git
git clone https://your-domain.railway.app/username/my-project.git
cd my-project
git add README.md
git commit -m "Initial commit"
git push -u origin main
```

### Setting up CI/CD with Forgejo Actions

Create `.forgejo/workflows/ci.yml` in your repository:

```yaml
name: CI
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
      - run: npm install
      - run: npm test
      - run: npm run build
```

### Using Webhooks

Configure webhooks to integrate with external services:

```bash
# Example webhook payload
curl -X POST "https://your-domain.railway.app/api/v1/repos/owner/repo/hooks" \
  -H "Authorization: token YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "forgejo",
    "config": {
      "url": "https://example.com/webhook",
      "content_type": "json"
    },
    "events": ["push", "pull_request"],
    "active": true
  }'
```

## Configuration

### Environment Variables

#### Automatically Generated Variables
- `POSTGRES_PASSWORD`: Database password (automatically generated for Railway deployments)
- `FORGEJO_SECRET_KEY`: Secret key for encryption (automatically generated for Railway deployments)

#### Required Variables
- None (all secrets are auto-generated)

#### Optional Variables
- `FORGEJO_VERSION`: Forgejo version (default: 9)
- `FORGEJO_ADMIN_USER`: Initial admin username (default: admin)
- `FORGEJO_ADMIN_PASSWORD`: Initial admin password (auto-generated if not set)
- `FORGEJO_ADMIN_EMAIL`: Admin email address (default: admin@example.com)
- `FORGEJO_APP_NAME`: Application name (default: Forgejo)
- `FORGEJO_RUN_MODE`: Run mode (default: prod)
- `FORGEJO_DISABLE_REGISTRATION`: Disable public registration (default: false)

#### Railway Automatic Variables
Railway automatically provides these variables:
- `RAILWAY_PUBLIC_DOMAIN`: Your application's public domain
- `PORT`: Port for the application to bind to

### Advanced Configuration

#### SMTP Email Configuration

Configure email notifications via environment variables:

```bash
FORGEJO_MAILER_ENABLED=true
FORGEJO_MAILER_FROM=forgejo@example.com
FORGEJO_MAILER_SMTP_ADDR=smtp.gmail.com
FORGEJO_MAILER_SMTP_PORT=587
FORGEJO_MAILER_USER=user@gmail.com
FORGEJO_MAILER_PASSWD=password
```

#### OAuth2 Authentication

Enable OAuth2 authentication (GitHub, GitLab, etc.):

1. Go to Site Administration > Authentication Sources
2. Add New Source > OAuth2
3. Configure provider details
4. Enable the authentication source

#### Package Registry

Enable package registry for Docker, npm, Maven, etc.:

```ini
[packages]
ENABLED = true
```

Packages are automatically enabled in this template.

#### SSH Configuration

SSH is available on port 22 (configurable):

```bash
# Clone via SSH
git clone ssh://git@your-domain.railway.app:22/username/repo.git
```

## API

Forgejo provides a comprehensive REST API compatible with Gitea and partially compatible with GitHub API.

### Repositories API
- `GET /api/v1/repos/search`: Search repositories
- `POST /api/v1/user/repos`: Create a repository
- `GET /api/v1/repos/{owner}/{repo}`: Get repository details

### Issues API
- `GET /api/v1/repos/{owner}/{repo}/issues`: List issues
- `POST /api/v1/repos/{owner}/{repo}/issues`: Create an issue
- `PATCH /api/v1/repos/{owner}/{repo}/issues/{index}`: Update an issue

### Users API
- `GET /api/v1/users/{username}`: Get user information
- `GET /api/v1/user`: Get authenticated user

For detailed API documentation, see the [Forgejo API Documentation](https://forgejo.org/docs/latest/user/api-usage/).

## Contributing

We welcome contributions to improve this Railway template!

### Development Setup
1. Fork this repository
2. Clone your fork: `git clone https://github.com/yourusername/durable-forgejo-railway-template.git`
3. Make your changes
4. Submit a pull request

### Guidelines
- Follow the existing code style and conventions
- Update documentation for configuration changes
- Ensure Railway compatibility
- Test deployments before submitting

## License

Licensed under the MIT License. See [LICENSE](LICENSE) for details.

## Support

- **Documentation**: [Forgejo Official Documentation](https://forgejo.org/docs/)
- **Repository**: [Forgejo Codeberg](https://codeberg.org/forgejo/forgejo)
- **Railway Docs**: [Railway Documentation](https://docs.railway.app)
- **Issues**: Report issues in the [GitHub Issues](https://github.com/durable-templates-railway/durable-forgejo-railway-template/issues)

## About Durable Programming

Durable Programming is the author of this template, though not of Forgejo itself.

For third-party commercial support, contact Durable Programming LLC at commercial@durableprogramming.com 

