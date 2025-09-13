FROM miktex/miktex:latest

# Add metadata labels for better image management
LABEL org.opencontainers.image.title="MiKTeX with Git" \
      org.opencontainers.image.description="A Docker image for MiKTeX with Git and retry logic for robust package updates." \
      org.opencontainers.image.source="https://github.com/blueberryapple/docker-miktex-with-git"

# Install system packages and clean up apt cache in the same layer
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends --no-install-suggests \
    git \
    libqt5core5a \
    libqt5gui5 \
    libqt5widgets5 \
    retry && \
    rm -rf /var/lib/apt/lists/*

# Configure MiKTeX
RUN miktexsetup --shared=yes finish && \
    initexmf --admin --set-config-value [MPM]AutoInstall=1 && \
    echo "--- Updating global MiKTeX packages ---" && \
    RETRY_GLOBAL_OUTPUT=$(retry -t 3 -d 10 -- timeout 600 miktex --admin packages update 2>&1) && \
    echo "$RETRY_GLOBAL_OUTPUT" && \
    if echo "$RETRY_GLOBAL_OUTPUT" | grep -q "invalid option"; then \
        echo "Error: retry command used with invalid options during global package update." && exit 1; \
    fi && \
    echo "--- Updating local MiKTeX packages ---" && \
    RETRY_LOCAL_OUTPUT=$(retry -t 3 -d 10 -- timeout 600 miktex packages update 2>&1) && \
    echo "$RETRY_LOCAL_OUTPUT" && \
    if echo "$RETRY_LOCAL_OUTPUT" | grep -q "invalid option"; then \
        echo "Error: retry command used with invalid options during local package update." && exit 1; \
    fi && \
    echo "--- Verifying package updates ---" && \
    miktex --version && \
    initexmf --report || echo "Update verification completed"

# Final system setup: update font cache and create runtime directory
RUN fc-cache -f -v && \
    mkdir -p /tmp/runtime-root && chmod 700 /tmp/runtime-root

# Set environment variables for MiKTeX and headless operation
ENV PATH="/usr/local/bin:$PATH" \
    QT_QPA_PLATFORM=offscreen \
    QT_QPA_PLATFORM_PLUGIN_PATH=/usr/lib/x86_64-linux-gnu/qt5/plugins/platforms \
    XDG_RUNTIME_DIR=/tmp/runtime-root \
    MPLBACKEND=Agg
