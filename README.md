# Tor Snowflake Proxy

A lightweight Docker image providing an HTTP proxy (Privoxy) over the Tor network using Snowflake bridges.

## Features

- Tor daemon
- Snowflake bridge support
- HTTP proxy (Privoxy) on port `8118`
- Suitable for Docker and TrueNAS SCALE

## Architecture

```text
                  HTTP
Application ─────────────► Privoxy (8118)
                                │
                                │ SOCKS5
                                ▼
                           Tor (9050)
                                │
                                │ Snowflake bridge
                                ▼
                           Tor Network
                                │
                                ▼
                            Internet
```

The application communicates with Privoxy over HTTP. Privoxy forwards all requests to the local Tor SOCKS5 proxy, which connects to the Tor network using a Snowflake bridge.

## Build

```bash
docker build -t tor-snowflake-proxy .
```

## Run

```bash
docker run -d \
  --name tor-snowflake \
  -p 8118:8118 \
  -v $(pwd)/torrc:/etc/tor/torrc:ro \
  -v tor-data:/var/lib/tor \
  tor-snowflake-proxy
```

## Configuration

### Tor

Create a `torrc` file from `torrc.example` and replace:

```text
Bridge snowflake <YOUR_BRIDGE_HERE>
```

with your own Snowflake bridge obtained from Tor Browser.


### Privoxy

No configuration is required. The image includes a default Privoxy configuration that forwards all traffic to Tor.

## Test

Verify the proxy:

```bash
curl --proxy http://127.0.0.1:8118 \
https://check.torproject.org/api/ip
```

If the proxy is working, a successful response will look like this:

```json
{
  "IsTor": true,
  "IP": "<TOR_EXIT_NODE_IP>"
}
```

## Using as an HTTP proxy

Set:
```text
HTTP_PROXY=http://<host>:8118
HTTPS_PROXY=http://<host>:8118
```

## TrueNAS SCALE

Create a Custom App using the image and mount the required volumes.

Mount:

| Host | Container |
|------|-----------|
| `/path/to/torrc` | `/etc/tor/torrc` (read-only) |
| `/path/to/data` | `/var/lib/tor` |

Expose port:

- `8118/TCP`

## License

MIT
