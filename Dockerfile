FROM miktex/miktex:latest

# Finish MiKTeX setup with shared installation
RUN miktexsetup --shared=yes finish

# Enable automatic package installation
RUN initexmf --admin --set-config-value [MPM]AutoInstall=1

# Update MikTeX packages
RUN mpm --admin --update

# Install additional system packages
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends --no-install-suggests \
    git && \
    rm -rf /var/lib/apt/lists/*

# Update font cache
RUN fc-cache -f -v

# Set environment variables for MiKTeX
ENV PATH="/usr/local/bin:$PATH"