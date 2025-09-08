FROM miktex/miktex:latest

# Install additional system packages and remove docs
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends --no-install-suggests \
    git-core && \
    rm -rf /var/lib/apt/lists/*

# Update font cache
RUN fc-cache -f -v

# Set environment variables for MiKTeX
ENV PATH="/usr/local/bin:$PATH"