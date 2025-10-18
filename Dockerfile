FROM codeberg.org/forgejo/forgejo:13

# Railway provides PostgreSQL database
ENV FORGEJO__database__DB_TYPE=postgres
ENV FORGEJO__database__HOST=${PGHOST}
ENV FORGEJO__database__PORT=${PGPORT}
ENV FORGEJO__database__NAME=${PGDATABASE}
ENV FORGEJO__database__USER=${PGUSER}
ENV FORGEJO__database__PASSWD=${PGPASSWORD}

# Basic Forgejo configuration
ENV FORGEJO__server__DOMAIN=${RAILWAY_STATIC_URL}
ENV FORGEJO__server__ROOT_URL=https://${RAILWAY_STATIC_URL}
ENV FORGEJO__server__HTTP_PORT=3000
ENV FORGEJO__server__PROTOCOL=https

# SSH configuration (Railway provides SSH access)
ENV FORGEJO__server__SSH_DOMAIN=${RAILWAY_STATIC_URL}
ENV FORGEJO__server__SSH_PORT=2222
ENV FORGEJO__server__SSH_LISTEN_PORT=2222

# Security settings
ENV FORGEJO__security__SECRET_KEY=${SECRET_KEY}
ENV FORGEJO__security__INTERNAL_TOKEN=${INTERNAL_TOKEN}

# Disable registration by default (can be enabled via env var)
ENV FORGEJO__service__DISABLE_REGISTRATION=true
ENV FORGEJO__service__ALLOW_ONLY_EXTERNAL_REGISTRATION=false

# Set user and group for Railway
ENV USER_UID=1000
ENV USER_GID=1000

# Expose ports
EXPOSE 3000 2222

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:3000/api/v1/version || exit 1

# Run as non-root user
USER 1000:1000

# Start Forgejo
CMD ["/usr/local/bin/gitea", "web"]