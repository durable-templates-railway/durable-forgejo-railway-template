FROM codeberg.org/forgejo/forgejo:13

# Set user and group for Railway
ENV USER_UID=1000
ENV USER_GID=1000

# Expose ports
EXPOSE 3000 2222

# Run as non-root user
USER 1000:1000

# Start Forgejo
CMD ["/usr/local/bin/gitea", "web"]