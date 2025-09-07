FROM miktex/miktex:latest

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends --no-install-suggests \
    git && \
    fc-cache -f -v && \
    rm -rf /var/lib/apt/lists/*