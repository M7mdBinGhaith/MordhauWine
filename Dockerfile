FROM cm2network/steamcmd
LABEL MAINTAINER=M7mdBinGhaith
USER root
ENV WineVersion 6.6~bullseye-1
ENV UID 1000
RUN dpkg --add-architecture i386 && \
        cd /tmp && \
        apt update && \
        apt -y install gnupg2 software-properties-common xvfb wget gosu cabextract && \
        wget -qO - https://dl.winehq.org/wine-builds/winehq.key | apt-key add - && \
        apt-add-repository https://dl.winehq.org/wine-builds/debian/ && \
        wget -O- -q https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/Release.key | apt-key add - && \
        echo "deb http://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10 ./" | tee /etc/apt/sources.list.d/wine-obs.list && \
        apt update && \
        apt -y install --no-install-recommends winehq-staging=${WineVersion} wine-staging=${WineVersion} wine-staging-amd64=${WineVersion} wine-staging-i386=${WineVersion} && \
        apt -y --purge remove software-properties-common gnupg2 && \
        apt -y autoremove && \
        rm -rf /var/lib/apt/lists/* /tmp/*
#Disable fixme prompts that fill the logs, activate it for debugging wine compatibility issues
ENV WINEDEBUG=fixme-all

ENV SteamID=629800 \
    MordhauDIR=/mordhau \
    Port=7777 \
    QueryPort=27015 \
    BeaconPort=15000 \
    ConfigDIR=/config \
    RCONPORT=2766
RUN wget -q -O /usr/sbin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
&& chmod +x /usr/sbin/winetricks
USER steam
ENV   WINEDLLOVERRIDES="mscoree,mshtml=" \
      WINEPREFIX=/home/steam/.wine \
      DISPLAY=:0 \
      DISPLAY_WIDTH=1024 \
      DISPLAY_HEIGHT=768 \
      DISPLAY_DEPTH=16 \
      XVFB=1
RUN xvfb-run --auto-servernum winetricks -q vcrun2019
USER root
ADD start.sh /etc/script/start.sh
RUN chmod +x /etc/script/start.sh
EXPOSE ${QueryPort}/udp ${BeaconPort}/udp ${Port}/udp ${RCONPORT}
VOLUME $MordhauDIR
VOLUME $ConfigDIR
ENTRYPOINT  ["/etc/script/start.sh"]
