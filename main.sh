#!/bin/bash

## Banner

clear
cat << EOF

 █████╗ ███╗   ███╗███████╗
██╔══██╗████╗ ████║██╔════╝
███████║██╔████╔██║███████╗
██╔══██║██║╚██╔╝██║╚════██║
██║  ██║██║ ╚═╝ ██║███████║  
╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝   
                  - useraid  

Welcome to AutomatedMediaSrv.     

For options and flags use -h or --help.
EOF

## Help Prompt

function help {
cat <<EOF


It is a script to setup a Media server that fetches and installs Movies, Shows, Automatically 
using various services running as docker containers.
    WARNING: Most of the functionality in this script requires root privileges. Use at
your own risk.

    options:

        -h|--help                Display all options and flags. 

        -a|--install-all         Run all Services, Programs and Containers.

        -c|--custom              Choose which services, containers and programs to Use.

        -r|--remove-all          Remove all Services, Programs and Containers.

        -x|--selective-remove    Choose which services, containers and programs to remove.

        -i|--info                Display Information and Status of all running services.

        -g|--graphical           Use Terminal Based GUI to setup.
                                (Pending Implementation)
EOF
}

## Variables

DATA_PATH=$HOME/data
DOCKDATA_PATH=$HOME/dockdata
UID=$(id -u)
GUID=$(id -g)
TIMEZONE=$(cat /etc/timezone)
TRANUSER='admin'
TRANPASS='adminpass'
DOCINT='86400'

## Placeholder 

function placeholder {
  echo -e "\nFunction yet to be implemented"
}

## GUI Dependencies

function gdepend {
  sudo apt-get -y install dialog

}

## Dependencies

function depend {
  # Installing Docker-CE  
  curl -fsSL https://get.docker.com -o docker.sh
  sh docker.sh
}

## System Upgrade

function sysup {
  sudo apt update
  sudo apt-get -y upgrade
}

## Install Cleanup

function cleanup {
  rm docker.sh
  sudo apt autoremove
  sudo apt autoclean
}

## Graphical 

function graphical {

  dialog --backtitle "GUI Configuration" \
      --title "GUI Configuration" --infobox "The GUI implementation is still a work in progress. Check the repository for progress on these feature." 10 30
}

## Services

### Indexer Pack - Prowlarr, Radarr, Sonarr

function indexPack {
  # Indexer Pack

  ## Prowlarr
  docker run -d \
    --name prowlarr \
    -e PUID=$UID \
    -e PGID=$GUID \
    -e TZ=$TIMEZONE \
    -p 9696:9696 \
    -v $DOCKDATA_PATH/prowlarr:/config \
    --restart unless-stopped \
    linuxserver/prowlarr:develop

  ## Sonarr
  docker run -d \
		--name sonarr \
		-e PUID=$UID \
		-e PGID=$GUID \
		-e TZ=$TIMEZONE \
		-p 8989:8989 \
		-v $DOCKDATA_PATH/sonarr:/config \
		-v $DATA_PATH/:/data \
		-v $DOCKDATA_PATH/qbittorrent/downloads:/downloads \
		--restart unless-stopped \
		linuxserver/sonarr:latest
  
  ## Radarr
  docker run -d \
		--name radarr \
		-e PUID=$UID \
		-e PGID=$GUID \
		-e TZ=$TIMEZONE \
		-p 7878:7878 \
		-v $DOCKDATA_PATH/radarr/data:/config \
		-v $DATA_PATH/:/data  \
		-v $DOCKDATA_PATH/qbittorrent/downloads:/downloads \
		--restart unless-stopped \
		linuxserver/radarr:latest

}

### Docker Monitoring - Yacht, Portainer

function docmon {
  # Docker Monitoring

  ## Portainer
  docker run -d \
    --name portainer \
    -p 9000:9000 \
    -p 9443:9443 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data \
    --restart=always \
    portainer/portainer-ce:latest

  ## Yacht
  docker run -d \
    --name yacht \
    -p 8000:8000 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v yacht:/config \
    --restart=always \
    selfhostedpro/yacht

}

### Webfront UI - Jellyfin, Jellyseerr

function webui {
  # Webfront UI

  ## Jellyfin
	docker run -d \
		--name jellyfin \
		-e PUID=$UID \
		-e PGID=$GUID \
		-e TZ=$TIMEZONE \
		-p 8096:8096 \
		-p 8920:8920  \
		-v $DOCKDATA_PATH/jellyfin/config:/config \
		-v $DOCKDATA_PATH/jellyfin/cache:/cache \
		-v $DATA_PATH/:/data \
		--restart unless-stopped \
		linuxserver/jellyfin:latest

  ## Jellyseerr
  docker run -d \
    --name jellyseerr \
    -e LOG_LEVEL=debug \
    -e TZ=$TIMEZONE \
    -p 5055:5055 \
    -v $DOCKDATA_PATH/jellyseerr/config:/app/config \
    --restart unless-stopped \
    fallenbagel/jellyseerr:latest

}

### Download Clients - qBittorrent, Deluge, Transmission

function downui {
  # Download Clients
  
  ## qBittorrent
	docker run -d \
		--name qbittorrent \
		-e PUID=$UID \
		-e PGID=$GUID \
		-e TZ=$TIMEZONE \
		-e WEBUI_PORT=8090 \
		-p 8090:8090 \
		-v $DOCKDATA_PATH/qbittorrent/appdata/config:/config \
		-v $DOCKDATA_PATH/qbittorrent/downloads:/downloads \
		-v $DATA_PATH/data:/data \
		--restart unless-stopped \
		linuxserver/qbittorrent:latest

  ## Deluge
  docker run -d \
    --name deluge \
    -e PUID=$UID \
    -e PGID=$GUID \
    -e TZ=$TIMEZONE \
    -e DELUGE_LOGLEVEL=error \
    -p 8112:8112 \
    -v $DOCKDATA_PATH/deluge/config:/config \
    -v $DOCKDATA_PATH/deluge/downloads:/downloads \
    --restart unless-stopped \
    linuxserver/deluge:latest

  ## Transmission
  docker run -d \
    --name transmission \
    -e PUID=$UID \
    -e PGID=$GUID \
    -e TZ=$TIMEZONE \
    -e USER=$TRANUSER \
    -e PASS=$TRANPASS \
    -p 9091:9091 \
    -p 51413:51413 \
    -p 51413:51413/udp \
    -v $DOCKDATA_PATH/transmission/config:/config \
    -v $DOCKDATA_PATH/transmission/downloads:/downloads \
    --restart unless-stopped \
    linuxserver/transmission:latest

}

### Additional Services - Bazarr, Filebrowser

function addserv {
  # Additional Services

  ## Bazarr
  docker run -d \
    --name bazarr \
    -e PUID=$UID \
    -e PGID=$GUID \
    -e TZ=$TIMEZONE \
    -p 6767:6767 \
    -v $DOCKDATA_PATH/bazarr/config:/config \
    -v $DATA_PATH:/data \
    --restart unless-stopped \
    linuxserver/bazarr:latest

  ## File Browser
  ### Creating DB
  touch $DOCKDATA_PATH/filebrowser/filebrowser.db
  docker run \
    --name filebrowser \
    -e PUID=$UID \
    -e PGID=$GUID \
    -p 8070:80 \
    -v /:/srv \
    -v $DOCKDATA_PATH/filebrowser/filebrowser.db:/database/filebrowser.db \
    -v $DOCKDATA_PATH/filebrowser/settings.json:/config/settings.json \
    --restart unless-stopped \
    filebrowser/filebrowser:latest

}

### Container Updater - Watchtower

function conupdate {
  # Container Updater

  ## Watchtower
	docker run -d \
    --name watchtower \
    -e WATCHTOWER_CLEANUP=true \
    -e WATCHTOWER_POLL_INTERVAL=$DOCINT \
    -v /var/run/docker.sock:/var/run/docker.sock \
    --restart always \
    containrrr/watchtower

}

### Server DashBoard - Heimdall, Organizer, Dashy

function srvdash {
  # Server DashBoard
  
  ## Heimdall
	docker run -d \
		--name heimdall \
		-e PUID=$UID \
		-e PGID=$GUID \
		-e TZ=$TIMEZONE \
		-p 80:80 \
		-p 443:443 \
		-v $DOCKDATA_PATH/heimdall:/config \
		--restart unless-stopped \
		linuxserver/heimdall:latest

  ## Organizr
  docker run -d \
    --name organizr \
    -e PUID=$UID \
		-e PGID=$GUID \
    -v $DOCKDATA_PATH/organizr:/config \
    -p 80:80 \
    -e fpm="false" \ 
    -e branch="v2-master" \ 
    organizr/organizr

  ## Dashy
  docker run -d \
    --name dashy \
    -p 80:80 \
    --restart=always \
    lissy93/dashy:latest

}

### Webhook Monitoring

function webhmon {

echo '#!/bin/bash
url="$(cat webhook.txt)"
websites_list="$(cat ip.txt):8096 $(cat ip.txt):9000 $(cat ip.txt):8989 $(cat ip.txt):7878 $(cat ip.txt):8090 $(cat ip.txt):5055"
curl -H "Content-Type: application/json" -X POST -d '{"content":"'" $(date) \n***Services*** "'"}'  $url
for website in ${websites_list} ; do
        status_code=$(curl --write-out %{http_code} --silent --output /dev/null -L ${website})

        if [[ "$status_code" -ne 200 ]] ; then
            if [[ "$website" = http://*.*.*.*:8096 ]] ; then
                domain="Jellyfin"
            elif [[ "$website" = http://*.*.*.*:9000 ]] ; then
                domain="Portainer"
            elif [[ "$website" = http://*.*.*.*:8989 ]] ; then
                domain="Sonarr"
            elif [[ "$website" = http://*.*.*.*:7878 ]] ; then
                domain="Radarr"
            elif [[ "$website" = http://*.*.*.*:8090 ]] ; then
                domain="qBittorrent"
            elif [[ "$website" = http://*.*.*.*:5055 ]] ; then
                domain="Jellyseerr"
            fi
            curl -H "Content-Type: application/json" -X POST -d '{"content":"'"${domain} is down with SC : ${status_code}"'"}'  $url
        else
            if [[ "$website" = http://*.*.*.*:8096 ]] ; then
                domain="Jellyfin"
            elif [[ "$website" = http://*.*.*.*:9000 ]] ; then
                domain="Portainer"
            elif [[ "$website" = http://*.*.*.*:8989 ]] ; then
                domain="Sonarr"
            elif [[ "$website" = http://*.*.*.*:7878 ]] ; then
                domain="Radarr"
            elif [[ "$website" = http://*.*.*.*:8090 ]] ; then
                domain="qBittorrent"
            elif [[ "$website" = http://*.*.*.*:5055 ]] ; then
                domain="Jellyseerr"
            fi
            curl -H "Content-Type: application/json" -X POST -d '{"content":"'"${domain} is up and running with SC : ${status_code}"'"}'  $url
        fi
done' >> webhmon.sh

}

## Flag Selector

while [ $# -gt 0 ]; do
  case $1 in
    -a|--install-all)
      placeholder
      exit
      ;;
    -c|--custom)
      placeholder
      exit
      ;;
    -r|--remove-all)
      placeholder
      exit
      ;;
    -x|--selective-remove)
      placeholder
      exit
      ;;
    -i|--info)
      placeholder
      exit
      ;;
    -h|--help)
      help
      exit
      ;;
    -g|--graphical)
      graphical
      exit
      ;;
    *)
      echo "Unknown option $1"
      help
      exit 1
      ;;
  esac
done