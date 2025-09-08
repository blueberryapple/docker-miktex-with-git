FROM miktex/miktex:latest

# Finish MiKTeX setup with shared installation
RUN miktexsetup --shared=yes finish

# Enable automatic package installation
RUN initexmf --admin --set-config-value [MPM]AutoInstall=1

# Install additional system packages
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends --no-install-suggests \
    git && \
    fc-cache -f -v && \
    rm -rf /var/lib/apt/lists/*


# Set environment variables for MiKTeX
ENV PATH="/usr/local/bin:$PATH"