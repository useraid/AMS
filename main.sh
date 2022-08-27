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
    --name=prowlarr \
    -e PUID=$UID \
    -e PGID=$GUID \
    -e TZ=$TIMEZONE \
    -p 9696:9696 \
    -v $DOCKDATA_PATH/prowlarr:/config \
    --restart unless-stopped \
    linuxserver/prowlarr:develop

  ## Sonarr
  docker run -d \
		--name=sonarr \
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
		--name=radarr \
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