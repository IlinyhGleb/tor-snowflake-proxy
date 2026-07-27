# Tor Snowflake Proxy

A lightweight Docker image providing a SOCKS5 proxy through the Tor network using Snowflake bridges.

## Features

- Tor daemon
- Snowflake bridge support
- SOCKS5 proxy on port `9050`
- Runs as a non-root user
- Suitable for Docker and TrueNAS SCALE

## Build

```bash
docker build -t tor-snowflake .
```

## Run

```bash
docker run -d \
  --name tor-snowflake \
  -p 9050:9050 \
  -v $(pwd)/torrc:/etc/tor/torrc:ro \
  -v tor-data:/var/lib/tor \
  tor-snowflake
```

## Configuration

Create a `torrc` file based on `torrc.example` and replace:

```text
Bridge snowflake <YOUR_BRIDGE_HERE>
```

with your own Snowflake bridge obtained from Tor Browser.

## Test

Verify the proxy:

```bash
curl --proxy socks5h://127.0.0.1:9050 \
https://check.torproject.org/api/ip
```

If the proxy is working, a successful response will look like this:

```bash
{"IsTor":true,"IP":"<TOR EXIT NODE PUBLIC IP ADDRESS>"}% 
```

## TrueNAS SCALE

This image can be deployed as a Custom App.

Mount:

| Host | Container |
|------|-----------|
| `/path/to/torrc` | `/etc/tor/torrc` (read-only) |
| `/path/to/data` | `/var/lib/tor` |

Expose port:

- `9050/TCP`

## License

MIT
