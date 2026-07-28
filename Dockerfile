FROM debian:bookworm-slim

LABEL org.opencontainers.image.title="Tor Snowflake Proxy"
LABEL org.opencontainers.image.description="HTTP proxy over Tor using Snowflake bridges"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.source="https://github.com/ilinyhgleb/tor-snowflake-proxy"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        tor \
        snowflake-client \
        privoxy \
        netcat-openbsd \
        ca-certificates \
        curl && \
    rm -rf /var/lib/apt/lists/*

# Create persistent Tor data directory
RUN mkdir -p /var/lib/tor && \
    chown -R debian-tor:debian-tor /var/lib/tor

VOLUME ["/var/lib/tor"]

# Copy Privoxy configuration
COPY privoxy/config /etc/privoxy/config

# Copy Tor configuration
#COPY torrc /etc/tor/torrc  # For local run (uncomment if you don't use shared volumes)

# Expose HTTP proxy
EXPOSE 8118


COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -fs --proxy http://127.0.0.1:8118 https://check.torproject.org/api/ip >/dev/null || exit 1

STOPSIGNAL SIGINT

ENTRYPOINT ["/usr/local/bin/start.sh"]
