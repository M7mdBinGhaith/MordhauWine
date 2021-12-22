#!/bin/bash
usermod -u ${UID} steam
chown steam:steam -R  ${MordhauDIR} ${ConfigDIR}
gosu steam bash -l -c  '${STEAMCMDDIR}/steamcmd.sh +@sSteamCmdForcePlatformType windows +force_install_dir ${MordhauDIR} +login anonymous +app_update ${SteamID} +quit && xvfb-run wine ${MordhauDIR}/MordhauServer.exe -log -Port=${Port} -QueryPort=${QueryPort} -RconPort=${RconPort} -Beaconport=${BeaconPort} -GAMEINI=${ConfigDIR}/Game.ini -ENGINEINI=${ConfigDIR}/Engine.ini'
