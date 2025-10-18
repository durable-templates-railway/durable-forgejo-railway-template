FROM codeberg.org/forgejo/forgejo:13

# Install postgresql-client for pg_isready command
USER root
RUN apk add --no-cache postgresql-client

# Set user and group for Railway
ENV USER_UID=1000
ENV USER_GID=1000

# Create necessary directories with correct permissions
RUN mkdir -p /data/gitea/conf && \
    chown -R 1000:1000 /data

# Copy entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh && \
    chown 1000:1000 /usr/local/bin/entrypoint.sh

# Expose ports
EXPOSE 3000 2222

# Run as non-root user
USER 1000:1000

# Working directory
WORKDIR /data

# Use custom entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]