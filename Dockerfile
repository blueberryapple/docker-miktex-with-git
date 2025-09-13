FROM miktex/miktex:latest

# Finish MiKTeX setup with shared installation
RUN miktexsetup finish

# Enable automatic package installation
RUN initexmf --set-config-value [MPM]AutoInstall=1

# Update MikTeX packages with exponential backoff retry mechanism
# Retry logic with exponential backoff is needed because MiKTeX package updates can fail with "Interrupted system call"
# errors due to filesystem watcher conflicts, resource constraints, or network issues.
# Exponential backoff (10s, 30s, 60s) reduces system load and gives more time for transient issues to resolve.
RUN attempt=1; \
    max_attempts=3; \
    while [ $attempt -le $max_attempts ]; do \
        echo "Attempt $attempt of $max_attempts - Updating MiKTeX packages"; \
        if timeout 600 miktex packages update; then \
            echo "Package update successful on attempt $attempt"; \
            break; \
        else \
            if [ $attempt -eq 1 ]; then \
                delay=10; \
            elif [ $attempt -eq 2 ]; then \
                delay=30; \
            else \
                delay=60; \
            fi; \
            if [ $attempt -lt $max_attempts ]; then \
                echo "Attempt $attempt failed, retrying in $delay seconds..."; \
                sleep $delay; \
            else \
                echo "All $max_attempts attempts failed"; \
            fi; \
        fi; \
        attempt=$((attempt + 1)); \
    done && \
    echo "Verifying package update..." && \
    miktex --version && \
    echo "Checking package repository status..." && \
    initexmf --report || echo "Update verification completed"

# Install additional system packages
# Install git and Qt libraries for latexmk (minimal platform)
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends --no-install-suggests \
    git \
    libqt5core5a \
    libqt5gui5 \
    libqt5widgets5 && \
    rm -rf /var/lib/apt/lists/*


# Update font cache
RUN fc-cache -f -v

# Set environment variables for MiKTeX
ENV PATH="/usr/local/bin:$PATH"
# Use offscreen Qt platform for headless environment
ENV QT_QPA_PLATFORM=offscreen
ENV QT_QPA_PLATFORM_PLUGIN_PATH=/usr/lib/x86_64-linux-gnu/qt5/plugins/platforms
ENV XDG_RUNTIME_DIR=/tmp/runtime-root
# Additional headless settings
ENV MPLBACKEND=Agg