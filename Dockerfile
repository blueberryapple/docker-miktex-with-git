FROM miktex/miktex:latest

# Disable file system watcher to avoid interrupted system calls
ENV MIKTEX_ENABLE_FILESYSTEMWATCHER=0

# Check for updates
RUN miktex packages update

# Mock last update check
RUN initexmf --set-config-value [MPM]LastUpdateCheck=20250912

# Install additional system packages
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends --no-install-suggests \
    git && \
    rm -rf /var/lib/apt/lists/*

# Update font cache
RUN fc-cache -f -v

# Set environment variables for MiKTeX
ENV PATH="/usr/local/bin:$PATH"