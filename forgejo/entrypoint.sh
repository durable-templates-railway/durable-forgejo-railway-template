#!/bin/bash
set -e

# Validate required environment variables
if [ -z "$FORGEJO_SECRET_KEY" ]; then
    echo "ERROR: FORGEJO_SECRET_KEY is not set"
    exit 1
fi

if [ -z "$POSTGRES_PASSWORD" ]; then
    echo "ERROR: POSTGRES_PASSWORD is not set"
    exit 1
fi

# Set environment variables for Forgejo configuration
export FORGEJO__server__HTTP_PORT="${PORT:-3000}"
export FORGEJO__server__DOMAIN="${RAILWAY_PUBLIC_DOMAIN:-localhost}"
export FORGEJO__server__ROOT_URL="https://${RAILWAY_PUBLIC_DOMAIN:-localhost}/"
export FORGEJO__server__SSH_DOMAIN="${RAILWAY_PUBLIC_DOMAIN:-localhost}"
export FORGEJO__server__SSH_PORT="22"

# Database configuration
export FORGEJO__database__DB_TYPE="postgres"
export FORGEJO__database__HOST="${POSTGRES_HOST:-localhost:5432}"
export FORGEJO__database__NAME="${POSTGRES_DB:-forgejo}"
export FORGEJO__database__USER="${POSTGRES_USER:-forgejo}"
export FORGEJO__database__PASSWD="${POSTGRES_PASSWORD}"

# Security settings
export FORGEJO__security__INSTALL_LOCK="true"
export FORGEJO__security__SECRET_KEY="${FORGEJO_SECRET_KEY}"

# Service settings
export FORGEJO__service__DISABLE_REGISTRATION="${FORGEJO_DISABLE_REGISTRATION:-false}"
export FORGEJO__service__REQUIRE_SIGNIN_VIEW="false"

# Features
export FORGEJO__actions__ENABLED="true"
export FORGEJO__packages__ENABLED="true"

# User settings
export USER_UID=1000
export USER_GID=1000

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL to be ready..."
until pg_isready -h "${POSTGRES_HOST%%:*}" -p "${POSTGRES_HOST##*:}" -U "${POSTGRES_USER}" 2>/dev/null; do
    echo "PostgreSQL is unavailable - sleeping"
    sleep 2
done

echo "PostgreSQL is ready - starting Forgejo"

# Start Forgejo
exec /usr/local/bin/gitea web
