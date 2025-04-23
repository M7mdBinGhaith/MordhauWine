FROM cm2network/steamcmd:latest
LABEL MAINTAINER=M7mdBinGhaith

USER root

# Use newer Debian version and Wine
ENV WineVersion 10.6~bookworm-1
ENV UID 1000

# Install dependencies
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        gnupg2 \
        software-properties-common \
        xvfb \
        wget \
        gosu \
        cabextract \
        curl \
        ca-certificates \
        vulkan-tools \
        libvulkan1 \
        libvulkan1:i386 \
        && \
    # Add Wine repository
    curl -fsSL https://dl.winehq.org/wine-builds/winehq.key | gpg --dearmor -o /usr/share/keyrings/winehq.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/winehq.gpg] https://dl.winehq.org/wine-builds/debian/ bookworm main" > /etc/apt/sources.list.d/winehq.list && \
    # Add Wine OBS repository
    curl -fsSL https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_12/Release.key | gpg --dearmor -o /usr/share/keyrings/wine-obs.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/wine-obs.gpg] https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_12/ ./" > /etc/apt/sources.list.d/wine-obs.list && \
    # Install Wine & dependencies
    apt-get update && \
    apt-get install -y --no-install-recommends \
        winehq-staging=${WineVersion} \
        wine-staging=${WineVersion} \
        wine-staging-amd64=${WineVersion} \
        wine-staging-i386=${WineVersion} \
        xauth && \
    # Cleanup
    apt-get remove -y software-properties-common gnupg2 && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/*

# Disable fixme prompts that fill the logs
ENV WINEDEBUG=fixme-all,err-all

# Server configuration
ENV SteamID=629800 \
    MordhauDIR=/mordhau \
    Port=7777 \
    QueryPort=27015 \
    BeaconPort=15000 \
    ConfigDIR=/config \
    RCONPORT=2766

# Install winetricks
RUN wget -q -O /usr/sbin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
    && chmod +x /usr/sbin/winetricks

USER steam

# Wine configuration
ENV WINEDLLOVERRIDES="mscoree,mshtml=" \
    WINEPREFIX=/home/steam/.wine \
    DISPLAY=:0 \
    DISPLAY_WIDTH=1024 \
    DISPLAY_HEIGHT=768 \
    DISPLAY_DEPTH=16 \
    XVFB=1 \
    WINEARCH=win64

# Initialize Wine prefix and install required Windows components
RUN xvfb-run --auto-servernum wineboot --init && \
    xvfb-run --auto-servernum winetricks -q vcrun2022 dotnet48 corefonts

USER root

# Add start script
COPY start.sh /etc/script/start.sh
RUN chmod +x /etc/script/start.sh

# Expose ports
EXPOSE ${QueryPort}/udp ${BeaconPort}/udp ${Port}/udp ${RCONPORT}

# Create volumes
VOLUME $MordhauDIR
VOLUME $ConfigDIR

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD netstat -an | grep ${Port} || exit 1

ENTRYPOINT ["/etc/script/start.sh"]
