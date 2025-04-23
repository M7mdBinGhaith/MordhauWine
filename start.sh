#!/bin/bash
set -e

# Function to log messages
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Update user ID if specified
if [ -n "${UID}" ]; then
    log "Updating steam user ID to ${UID}"
    usermod -u ${UID} steam
fi

# Set proper permissions
log "Setting permissions for Mordhau directories"
chown steam:steam -R ${MordhauDIR} ${ConfigDIR}

# Start the server
log "Starting Mordhau server..."
exec gosu steam bash -l -c '
    # Update or install the server
    echo "[$(date "+%Y-%m-%d %H:%M:%S")] Updating/installing Mordhau server..."
    ${STEAMCMDDIR}/steamcmd.sh \
        +@sSteamCmdForcePlatformType windows \
        +force_install_dir ${MordhauDIR} \
        +login anonymous \
        +app_update ${SteamID} \
        +quit

    # Check if the server executable exists
    if [ ! -f "${MordhauDIR}/MordhauServer.exe" ]; then
        echo "[$(date "+%Y-%m-%d %H:%M:%S")] Error: MordhauServer.exe not found!"
        exit 1
    fi

    # Start the server
    echo "[$(date "+%Y-%m-%d %H:%M:%S")] Launching Mordhau server..."
    echo "[$(date "+%Y-%m-%d %H:%M:%S")] Using ports: Port=${Port}, QueryPort=${QueryPort}, RCONPORT=${RCONPORT}, BeaconPort=${BeaconPort}"
    
    xvfb-run wine ${MordhauDIR}/MordhauServer.exe \
        -log \
        -Port=${Port} \
        -QueryPort=${QueryPort} \
        -RconPort=${RCONPORT} \
        -Beaconport=${BeaconPort} \
        2>&1 | tee ${MordhauDIR}/server.log
'
