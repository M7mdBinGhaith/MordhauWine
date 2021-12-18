FROM cm2network/steamcmd
USER root
ENV WineVersion 6.4~buster-1
ENV UID 1000

RUN dpkg --add-architecture i386 && \
        apt update && \
        apt -y install gnupg2 software-properties-common wget libstb0 libstb0:i386 libavutil56:i386 libavutil56 libavcodec58:i386 libavcodec58 && \
        wget -qO - https://dl.winehq.org/wine-builds/winehq.key | apt-key add - && \
        apt-add-repository https://dl.winehq.org/wine-builds/debian/ && \
        wget -O- -q https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/Release.key | apt-key add - && \
        echo "deb http://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10 ./" | tee /etc/apt/sources.list.d/wine-obs.list && \
        apt update && \
        apt -y install --install-recommends winehq-staging=${WineVersion} wine-staging=${WineVersion} wine-staging-amd64=${WineVersion} wine-staging-i386=${WineVersion} && \
        apt -y --purge remove software-properties-common gnupg2 && \
        wget https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/amd64/libfaudio0_20.01-0~buster_amd64.deb && apt install ./libfaudio0_20.01-0~buster_amd64.deb -y && \
        wget https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/i386/libfaudio0_20.01-0~buster_i386.deb && apt install ./libfaudio0_20.01-0~buster_i386.deb -y && \
        apt -y autoremove && \
        rm -rf /var/lib/apt/lists/*
#Disable fixme prompts that fill the logs, activate it for debugging wine compatibility issues
ENV WINEDEBUG=fixme-all

ENV SteamID 629800
ENV MordhauDIR /mordhau
ENV Port 7777
ENV QueryPort 27015
ENV BeaconPort 15000
ENV ConfigDIR /config

RUN mkdir ${MordhauDIR} && mkdir ${ConfigDIR}
RUN  chown steam -R  ${MordhauDIR} ${ConfigDIR}  && \
     usermod -u ${UID} steam 
EXPOSE ${QueryPort}/udp ${BeaconPort}/udp ${Port}/udp
USER steam

VOLUME $MordhauDIR
VOLUME $ConfigDIR

ENTRYPOINT ${STEAMCMDDIR}/steamcmd.sh +@sSteamCmdForcePlatformType windows +force_install_dir ${MordhauDIR} +login anonymous  +app_update ${SteamID} +quit && wine ${MordhauDIR}/MordhauServer.exe -log -Port=${Port} -QueryPort=${QueryPort} -Beaconport=${BeaconPort} -GAMEINI=${ConfigDIR}/Game.ini -ENGINEINI=${ConfigDIR}/Engine.ini
