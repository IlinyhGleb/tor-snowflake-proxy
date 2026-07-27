FROM debian:bookworm-slim

LABEL org.opencontainers.image.title="Tor + Snowflake SOCKS Proxy"
LABEL org.opencontainers.image.description="Tor daemon using Snowflake bridges"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        tor \
        snowflake-client \
        netcat-openbsd \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Create persistent Tor data directory
RUN mkdir -p /var/lib/tor && \
    chown -R debian-tor:debian-tor /var/lib/tor

# Prepare Tor configuration (torcc) directory
RUN mkdir -p /etc/tor

# Copy Tor configuration
#COPY torrc /etc/tor/torrc  # for local run

# Expose SOCKS proxy
EXPOSE 9050

# Persist Tor state
VOLUME ["/var/lib/tor"]

USER debian-tor

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD sh -c 'nc -z 127.0.0.1 9050'

STOPSIGNAL SIGINT

ENTRYPOINT ["tor"]
CMD ["-f", "/etc/tor/torrc"]
