FROM miktex/miktex:latest

# Disable file system watcher to avoid interrupted system calls
ENV MIKTEX_ENABLE_FILESYSTEMWATCHER=0
RUN initexmf --admin --set-config-value [internal]enableFileSystemWatcher=false

# Finish MiKTeX setup with shared installation
RUN miktexsetup --shared=yes finish

# Enable automatic package installation
RUN initexmf --admin --set-config-value [MPM]AutoInstall=1

# Update MikTeX packages
RUN miktex --admin packages update

# Install additional system packages
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends --no-install-suggests \
    git && \
    rm -rf /var/lib/apt/lists/*

# Update font cache
RUN fc-cache -f -v

# Set environment variables for MiKTeX
ENV PATH="/usr/local/bin:$PATH"