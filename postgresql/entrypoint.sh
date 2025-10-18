#!/bin/bash
set -e

# Validate required environment variables
if [ -z "$POSTGRES_PASSWORD" ]; then
    echo "ERROR: POSTGRES_PASSWORD is not set"
    exit 1
fi

# Set PostgreSQL environment variables (with defaults)
export POSTGRES_USER="${POSTGRES_USER:-forgejo}"
export POSTGRES_DB="${POSTGRES_DB:-forgejo}"

# Log connection details for debugging
echo "PostgreSQL connection details:"
echo "Host: ${RAILWAY_PRIVATE_DOMAIN:-localhost}"
echo "Port: 5432"
echo "User: ${POSTGRES_USER}"
echo "Database: ${POSTGRES_DB}"

# Run the original PostgreSQL entrypoint
exec docker-entrypoint.sh postgres
