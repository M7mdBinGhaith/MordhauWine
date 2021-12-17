# MordhauWine
Mordhau Docker container with wine to run mods that are not supported for the Linux version of Mordhau and potentially saving ram by elimnating windows os and running headless linux server if you prefer to.
# Docker compose 
You can easily install Docker compose and copy the below content and configure it to suit your need and save it to docker-compose.yml and <b>run</b> docker-compose up <br> 
the file in the repo without explanition if you prefer download that
```
version: '3.3'
services:
  Mordhau:
    restart: unless-stopped
    container_name: mordhau
    image: m7mdbinghaith/mordhau
    network_mode: "bridge"
    volumes:
      - /home/mohammad/mordhau/server:/mordhau #change to your path before : so it would go as /yourpath/:/mordhau
      - /home/mohammad/mordhau/config:/config  #change to your path before : so it would go as /yourpath/:/config
    tty: true
    ports:
      - "7777:7777/udp"
      - "27015:27015/udp"
      - "15000:15000/tcp"
    environment:
      - UID=1000 # set this to match your UID to get your UID in linux type this in the terminal  id -u ${USER}
      #- Port=7777  # I recommend you change from port bindings above and leave this to default  
      #- QueryPort=27015
      #- BeaconPort=15000
    cap_add:
      - CAP_NET_ADMIN
```
