FROM miktex/miktex:latest

# Simple MiKTeX setup
RUN miktexsetup finish && \
    initexmf --set-config-value [MPM]AutoInstall=1

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

# Set environment variables for MiKTeX and Qt
ENV PATH="/usr/local/bin:$PATH"
# Use minimal Qt platform for headless GitHub Actions environment
ENV QT_QPA_PLATFORM=minimal
ENV QT_QPA_PLATFORM_PLUGIN_PATH=/usr/lib/x86_64-linux-gnu/qt5/plugins/platforms
ENV XDG_RUNTIME_DIR=/tmp/runtime-root
# Additional headless settings
ENV MPLBACKEND=Agg