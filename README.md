# Mordhau Server Docker Container

A Docker container for running a Mordhau game server using Wine, optimized for headless Linux operation.

## Features

- Runs Mordhau server using Wine for full mod support
- Automatic updates and server management
- RCON support for remote administration
- Persistent data storage

## Installation

### Using Docker Compose

1. Create `docker-compose.yml`:
```yaml
version: '3.3'
services:
  Mordhau-Wine:
    restart: unless-stopped
    container_name: mordhau-server
    image: m7mdbinghaith/mordhau
    network_mode: "bridge"
    volumes:
      - ./mordhau/server:/mordhau
      - ./mordhau/config:/config
    ports:
      - "7777:7777/udp"
      - "27015:27015/udp"
      - "15000:15000/udp"
      - "2766:2766"
    environment:
      - UID=1000
    cap_add:
      - CAP_NET_ADMIN
```

2. Start the server:
```bash
docker-compose up -d
```

### Using Docker

```bash
docker run -d \
  --name mordhau-server \
  -p 7777:7777/udp \
  -p 27015:27015/udp \
  -p 15000:15000/udp \
  -p 2766:2766 \
  -v ./mordhau/server:/mordhau \
  -v ./mordhau/config:/config \
  m7mdbinghaith/mordhau
```

## Port Configuration

- `7777/UDP`: Game Server
- `27015/UDP`: Server Query
- `15000/UDP`: Server Beacon
- `2766/TCP`: RCON

## Firewall Configuration

Ensure these ports are open in your firewall:
- UDP: 7777, 27015, 15000
- TCP: 2766

## Server Management

- View logs: `docker logs mordhau-server`
- RCON access: Port 2766
- Configuration: Modify files in `./mordhau/config`

## Troubleshooting

1. **Server Not Showing**
   - Check port forwarding
   - Verify firewall settings
   - Check server logs

2. **Connection Issues**
   - Verify network connectivity
   - Check router port forwarding
   - Ensure correct firewall rules

