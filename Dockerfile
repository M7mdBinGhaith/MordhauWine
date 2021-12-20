FROM cm2network/steamcmd
LABEL MAINTAINER=M7mdBinGhaith
USER root
ENV WineVersion 6.4~buster-1
ENV UID 1000
RUN dpkg --add-architecture i386 && \
        cd /tmp && \
        apt update && \
        apt -y install gnupg2 software-properties-common wget gosu && \
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

ENV SteamID 629800
ENV MordhauDIR /mordhau
ENV Port 7777
ENV QueryPort 27015
ENV BeaconPort 15000
ENV ConfigDIR /config
ENV RCONPORT 2766

RUN mkdir ${MordhauDIR} && mkdir ${ConfigDIR}
EXPOSE ${QueryPort}/udp ${BeaconPort}/udp ${Port}/udp ${RCONPORT}


VOLUME $MordhauDIR
VOLUME $ConfigDIR
ADD start.sh /etc/script/start.sh
RUN chmod +x /etc/script/start.sh
ENTRYPOINT  ["/etc/script/start.sh"]