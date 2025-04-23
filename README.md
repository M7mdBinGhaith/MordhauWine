# Mordhau Server Docker Container

A Docker container for running a Mordhau game server using Wine, allowing for mod support and optimized resource usage by running on a headless Linux server.

## Features

- Runs Mordhau server using Wine for full mod support
- Optimized for Linux headless operation
- Automatic updates and server management
- RCON support for remote administration
- Persistent data storage using Docker volumes

## Prerequisites

- Docker and Docker Compose installed
- Linux host system
- Sufficient system resources (RAM, CPU)
- Required ports open on firewall

## Port Configuration

The server uses the following ports:
- `7777/UDP`: Main game server port
- `27015/UDP`: Server query port
- `15000/UDP`: Server beacon port
- `2766/TCP`: RCON port for server administration

## Installation

### Using Docker Compose (Recommended)

1. Create a `docker-compose.yml` file with the following content:

```yaml
version: '3.3'
services:
  Mordhau:
    restart: unless-stopped
    container_name: mordhau-server
    image: m7mdbinghaith/mordhau
    network_mode: "bridge"
    volumes:
      - mordhau-data:/mordhau
      - mordhau-config:/config
    ports:
      - "7777:7777/udp"
      - "27015:27015/udp"
      - "15000:15000/udp"
      - "2766:2766"
    environment:
      - UID=1000
    cap_add:
      - CAP_NET_ADMIN

volumes:
  mordhau-data:
  mordhau-config:
```

2. Start the container:
```bash
docker-compose up -d
```

### Using Docker Directly

Run the container:
```bash
docker run -d \
  --name mordhau-server \
  -p 7777:7777/udp \
  -p 27015:27015/udp \
  -p 15000:15000/udp \
  -p 2766:2766 \
  -v mordhau-data:/mordhau \
  -v mordhau-config:/config \
  m7mdbinghaith/mordhau
```

## Server Management

### Viewing Logs
```bash
docker logs mordhau-server
```

### RCON Access
Connect to the server using an RCON client on port 2766. Default RCON password is set in the server configuration.

### Server Configuration
Server configuration files are stored in the `mordhau-config` volume. You can modify settings like:
- Server name
- Game mode
- Player count
- Password protection
- RCON password

## Firewall Configuration

Ensure the following ports are open on your firewall:
```bash
sudo firewall-cmd --permanent --add-port=7777/udp
sudo firewall-cmd --permanent --add-port=27015/udp
sudo firewall-cmd --permanent --add-port=15000/udp
sudo firewall-cmd --permanent --add-port=2766/tcp
sudo firewall-cmd --reload
```

## Troubleshooting

1. **Server Not Showing in Browser**
   - Verify all ports are open and forwarded correctly
   - Check server logs for any errors
   - Ensure the server is properly broadcasting

2. **Connection Issues**
   - Verify client can reach the server IP
   - Check firewall settings
   - Ensure correct port forwarding on router

3. **Performance Issues**
   - Monitor system resources
   - Adjust player count if necessary
   - Check for any network bottlenecks

## Contributing

Feel free to submit issues and enhancement requests!

## License

This project is licensed under the MIT License - see the LICENSE file for details.
