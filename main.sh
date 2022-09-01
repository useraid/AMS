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


This program setups a Media server that fetches and installs Movies, Shows, Automatically 
using various services running as docker containers.
    WARNING: Some of the functionality in this script requires root privileges. Use at
your own risk.

    options:

        -h|--help                Display all options and flags. 

        -g|--graphical           Run all Services, Programs and Containers.

        -c|--cli                 Choose which services, containers and programs to Use.
                                  (Pending Implementation)

        -i|--info                Display Information and Status of all running services.

        -s|--status              Display Status of all the services.


EOF
}

## Variables

DATA_PATH=$HOME/data
DOCKDATA_PATH=$HOME/dockdata
GUID=$(id -g)
SID=$(id -u)
TIMEZONE=$(cat /etc/timezone)
TRANUSER='admin'
TRANPASS='adminpass'
DOCINT='86400'
IPADDR=$(hostname -I | cut -d' ' -f1)

## Placeholder 

function placeholder {
  echo -e "\nFunction yet to be implemented"
}

## Set Hostname

function hostn {

  HNAME=$(dialog --title "Changing Hostname" --inputbox "Enter New Hostname" 10 100 3>&1 1>&2 2>&3)
  clear
  sudo hostnamectl set-hostname $HNAME
}

## Status Monitoring function

function statusinfo {

  # ANSI color
  clear='\033[0m' # Clearing color

  ipaddr=$(hostname -I | cut -d' ' -f1)
  websites_list="http://$ipaddr:8096 http://$ipaddr:9000 http://$ipaddr:8070 http://$ipaddr:9696 http://$ipaddr:6767 http://$ipaddr:8989 http://$ipaddr:7878 http://$ipaddr:8090 http://$ipaddr:5055"
  for website in ${websites_list} ; do
          status_code=$(curl --write-out %{http_code} --silent --output /dev/null -L ${website})

          if [[ "$status_code" -ne 200 ]] ; then
            color='\033[0;31m' # Setting color to red.
              if [[ "$website" = http://*.*.*.*:8096 ]] ; then
                  JFstat="Not Active"
              elif [[ "$website" = http://*.*.*.*:9000 ]] ; then
                  PTstat="Not Active"
              elif [[ "$website" = http://*.*.*.*:8070 ]] ; then
                  FBstat="Not Active"
              elif [[ "$website" = http://*.*.*.*:9696 ]] ; then
                  PLstat="Not Active"
              elif [[ "$website" = http://*.*.*.*:6767 ]] ; then
                  BZstat="Not Active"
              elif [[ "$website" = http://*.*.*.*:8989 ]] ; then
                  SNstat="Not Active"
              elif [[ "$website" = http://*.*.*.*:7878 ]] ; then
                  RDstat="Not Active"
              elif [[ "$website" = http://*.*.*.*:8090 ]] ; then
                  QBstat="Not Active"
              elif [[ "$website" = http://*.*.*.*:5055 ]] ; then
                  JSstat="Not Active"
              fi
          else
              color='\033[0;32m' # Setting color to green.
              if [[ "$website" = http://*.*.*.*:8096 ]] ; then
                  JFstat="Active"
              elif [[ "$website" = http://*.*.*.*:9000 ]] ; then
                  PTstat="Active"
              elif [[ "$website" = http://*.*.*.*:8070 ]] ; then
                  FBstat="Active"
              elif [[ "$website" = http://*.*.*.*:9696 ]] ; then
                  PLstat="Active"
              elif [[ "$website" = http://*.*.*.*:6767 ]] ; then
                  BZstat="Active"
              elif [[ "$website" = http://*.*.*.*:8989 ]] ; then
                  SNstat="Active"
              elif [[ "$website" = http://*.*.*.*:7878 ]] ; then
                  RDstat="Active"
              elif [[ "$website" = http://*.*.*.*:8090 ]] ; then
                  QBstat="Active"
              elif [[ "$website" = http://*.*.*.*:5055 ]] ; then
                  JSstat="Active"
              fi
          fi
  done
  
  # Status Output

  echo -e "Jellyfin is ${color}$JFstat${clear}"
  echo -e "Portainer is ${color}$PTstat${clear}"
  echo -e "File Browser is ${color}$FBstat${clear}"
  echo -e "Prowlarr is ${color}$PLstat${clear}"
  echo -e "Bazarr is ${color}$BZstat${clear}"
  echo -e "Sonarr is ${color}$SNstat${clear}"
  echo -e "Radarr is ${color}$RDstat${clear}"
  echo -e "qBittorrent is ${color}$QBstat${clear}"
  echo -e "Jellyseerr is ${color}$JSstat${clear}"

}

## Information

function info {
  clear
  dialog --backtitle "Information" \
      --title "Information" --msgbox "Use the following addresses for the services: \n\n \
Container Management : \n\n \
Portainer -     $IPADDR:9000 \n\n \
Indexers : \n\n \
Prowlarr -      $IPADDR:9696 \n \
Sonarr -        $IPADDR:8989 \n \
Radarr -        $IPADDR:7878 \n\n \
Webfront UI : \n\n \
Jellyfin -      $IPADDR:8096 \n \
qBittorrent -   $IPADDR:8090 \n\n \
Server Monitoring Dashboard : \n\n \
Cockpit -       $IPADDR:9090 \n \
Webmin -        $IPADDR:10000 \n\n \
Additional Services : \n\n \
Heimdall -      $IPADDR:80 \n \
Filebrowser -   $IPADDR:8070 \n \
Bazarr -        $IPADDR:6767 \n" 20 60
  clear

}

## GUI Dependencies

function gdepend {

  # Installing dialog
  if [ ! -f $HOME/.depend/dialog ]; then
    sudo apt-get -y install dialog
    touch $HOME/.depend/dialog
  else
    echo "Continuing..."
  fi

}

## Dependencies

function depend {
  mkdir -p $HOME/.depend
  # Installing Docker-CE
  if [ ! -f $HOME/.depend/docker ]; then  
    curl -fsSL https://get.docker.com -o docker.sh
    sh docker.sh
    touch $HOME/.depend/docker
    ## Adding current user to docker group
    sudo usermod -aG docker $USER
  else
    echo "Continuing..."
  fi

  # Installing curl
  if [ ! -f $HOME/.depend/curl ]; then  
    sudo apt-get -y install curl
    touch $HOME/.depend/curl
  else
    echo "Continuing..."
  fi
  
}

## System Upgrade

function sysup {
  sudo apt update
  sudo apt-get -y upgrade
}

## Install Cleanup

function cleanup {
  rm docker.sh
  rm webhmon.sh
  sudo apt autoremove
  sudo apt autoclean
}

## Graphical 

function graphical {

  dialog --backtitle "GUI Configuration" \
      --title "GUI Configuration" --msgbox "The GUI implementation is still a work in progress. Check the repository for progress on these feature." 10 30
      clear
}

## No selection prompt

function nosel {
  dialog \
      --title "No Selection Made" --msgbox "The User choose cancel or No selection was made." 10 30
      clear
}

## Services

### Indexers and ARR selection - Prowlarr, Radarr, Sonarr, Mylarr, Lidarr

function indexPack {
  # Indexers and ARR selection

  INDEXSEL=$(dialog --title "Choose Indexers" --separate-output --checklist "Choose using SPACE and next menu using ENTER" 10 35 4 \
    "1" "Prowlarr" OFF \
    "2" "Sonarr" OFF \
    "3" "Radarr" OFF 3>&1 1>&2 2>&3)
    clear

}

### Docker Monitoring - Yacht, Portainer

function docmon {
  # Docker Monitoring

  DOCMONSEL=$(dialog --title "Choose Docker Container Manager" --separate-output --checklist "Choose using SPACE and next menu using ENTER" 10 35 4 \
    "1" "Portainer" OFF \
    "2" "Yacht" OFF 3>&1 1>&2 2>&3)
    clear

}

### Webfront UI - Jellyfin, Jellyseerr

function webui {
  # Webfront UI

  WEBUISEL=$(dialog --title "Choose Web UI Services" --separate-output --checklist "Choose using SPACE and next menu using ENTER" 10 35 4 \
    "1" "Jellyfin" OFF \
    "2" "Jellyseerr" OFF 3>&1 1>&2 2>&3)
    clear

}

### Download Clients - qBittorrent, Deluge, Transmission

function downui {
  # Download Clients

  DOWNSEL=$(dialog --title "Choose Download Client" --separate-output --checklist "Choose using SPACE and next menu using ENTER" 10 35 4 \
    "1" "qBittorrent" OFF \
    "2" "Deluge" OFF \
    "3" "Transmission" OFF 3>&1 1>&2 2>&3)
    clear

}

### Additional Services - Bazarr, Filebrowser

function addserv {
  # Additional Services

  ADDSERSEL=$(dialog --title "Choose Additional Services" --separate-output --checklist "Choose using SPACE and next menu using ENTER" 10 35 4 \
    "1" "Bazarr" OFF \
    "2" "File Browser" OFF 3>&1 1>&2 2>&3)
    clear

}

### Container Updater - Watchtower

function conupdate {
  # Container Updater
  if dialog --yesno "Do you want to use container service that will automatically update all your containers (Watchtower) ?" 10 50; then
    clear
    ## Watchtower
    docker run -d \
      --name watchtower \
      -e WATCHTOWER_CLEANUP=true \
      -e WATCHTOWER_POLL_INTERVAL=$DOCINT \
      -v /var/run/docker.sock:/var/run/docker.sock \
      --restart always \
      containrrr/watchtower
  else
    clear
    echo "Not installing Watchtower"
  fi

}

### Server DashBoard - Heimdall, Organizer, Dashy

function srvdash {
  # Server DashBoard

  DASHSEL=$(dialog --title "Choose Server Dashboard" --separate-output --checklist "Choose using SPACE and next menu using ENTER" 10 35 4 \
    "1" "Heimdall" OFF \
    "2" "Organizr" OFF \
    "3" "Dashy" OFF 3>&1 1>&2 2>&3)
    clear

}

### Webhook Monitoring ####################### OPTIMIZE THIS ####################

function webhmon {
  WEBHOOK=$(dialog --inputbox "Enter Webhook URL" 10 100 3>&1 1>&2 2>&3)
echo '#!/bin/bash
url="$(cat webhook.txt)"
ipaddr=$(hostname -I | cut -d' ' -f1)
websites_list="http://$ipaddr:8096 http://$ipaddr:9000 http://$ipaddr:8989 http://$ipaddr:7878 http://$ipaddr:8090 http://$ipaddr:5055"
curl -H "Content-Type: application/json" -X POST -d '{"content":"'" $(date) \n***Services*** "'"}'  $url
for website in ${websites_list} ; do
        status_code=$(curl --write-out %{http_code} --silent --output /dev/null -L ${website})

        if [[ "$status_code" -ne 200 ]] ; then
            if [[ "$website" = http://*.*.*.*:8096 ]] ; then
                domain="Jellyfin"
            elif [[ "$website" = http://*.*.*.*:9000 ]] ; then
                domain="Portainer"
            elif [[ "$website" = http://*.*.*.*:8070 ]] ; then
                domain="Filebrowser"
            elif [[ "$website" = http://*.*.*.*:9696 ]] ; then
                domain="Prowlarr"
            elif [[ "$website" = http://*.*.*.*:6767 ]] ; then
                domain="Bazarr"
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
            elif [[ "$website" = http://*.*.*.*:8070 ]] ; then
                domain="Filebrowser"
            elif [[ "$website" = http://*.*.*.*:9696 ]] ; then
                domain="Prowlarr"
            elif [[ "$website" = http://*.*.*.*:6767 ]] ; then
                domain="Bazarr"
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
sudo mkdir -p /etc/scripts
chmod +x webhmon.sh
echo "$WEBHOOK" >> webhook.txt
mv webhook.txt /etc/scripts/
mv webhmon.sh /etc/scripts/
clear

}

## Monitoring

function monitor {
  # Monitoring UI

  MONSEL=$(dialog --title "Choose Monitoring Services" --separate-output --checklist "Choose using SPACE and next menu using ENTER" 10 35 4 \
    "1" "Cockpit" OFF \
    "2" "Webmin" OFF 3>&1 1>&2 2>&3)
    clear

}

## Installer

function startinstall {
  # Indexers

  if [ -z "$INDEXSEL" ]; then
    nosel
  else
    for INDEXSEL in $INDEXSEL; do
      case "$INDEXSEL" in
      "1")
        ## Prowlarr
        docker run -d \
          --name prowlarr \
          -e PUID=$SID \
          -e PGID=$GUID \
          -e TZ=$TIMEZONE \
          -p 9696:9696 \
          -v $DOCKDATA_PATH/prowlarr:/config \
          --restart unless-stopped \
          linuxserver/prowlarr:develop
        ;;
      "2")
        ## Sonarr
        docker run -d \
          --name sonarr \
          -e PUID=$SID \
          -e PGID=$GUID \
          -e TZ=$TIMEZONE \
          -p 8989:8989 \
          -v $DOCKDATA_PATH/sonarr:/config \
          -v $DATA_PATH/:/data \
          -v $DOCKDATA_PATH/qbittorrent/downloads:/downloads \
          --restart unless-stopped \
          linuxserver/sonarr:latest        
        ;;
      "3")
        ## Radarr
        docker run -d \
          --name radarr \
          -e PUID=$SID \
          -e PGID=$GUID \
          -e TZ=$TIMEZONE \
          -p 7878:7878 \
          -v $DOCKDATA_PATH/radarr/data:/config \
          -v $DATA_PATH/:/data  \
          -v $DOCKDATA_PATH/qbittorrent/downloads:/downloads \
          --restart unless-stopped \
          linuxserver/radarr:latest
        ;;
      *)
        echo "Unsupported item $INDEXSEL!" >&2
        exit 1
        ;;
      esac
    done
  fi

  # Docker Monitoring

  if [ -z "$DOCMONSEL" ]; then
    clear
    nosel
  else
    for DOCMONSEL in $DOCMONSEL; do
      case "$DOCMONSEL" in
      "1")
        ## Portainer
        docker run -d \
            --name portainer \
            -p 9000:9000 \
            -p 9443:9443 \
            -v /var/run/docker.sock:/var/run/docker.sock \
            -v portainer_data:/data \
            --restart=always \
            portainer/portainer-ce:latest
        ;;
      "2")
        ## Yacht
        docker run -d \
            --name yacht \
            -p 8000:8000 \
            -v /var/run/docker.sock:/var/run/docker.sock \
            -v yacht:/config \
            --restart=always \
            selfhostedpro/yacht
        ;;
      *)
        echo "Unsupported item $DOCMONSEL!" >&2
        exit 1
        ;;
      esac
    done
  fi

  # WebUI

  if [ -z "$WEBUISEL" ]; then
    clear
    nosel
  else
    for WEBUISEL in $WEBUISEL; do
      case "$WEBUISEL" in
      "1")
    ## Jellyfin
        docker run -d \
            --name jellyfin \
            -e PUID=$SID \
            -e PGID=$GUID \
            -e TZ=$TIMEZONE \
            -p 8096:8096 \
            -p 8920:8920  \
            -v $DOCKDATA_PATH/jellyfin/config:/config \
            -v $DOCKDATA_PATH/jellyfin/cache:/cache \
            -v $DATA_PATH/:/data \
            --restart unless-stopped \
            linuxserver/jellyfin:latest
        ;;
      "2")
    ## Jellyseerr
        docker run -d \
            --name jellyseerr \
            -e LOG_LEVEL=debug \
            -e TZ=$TIMEZONE \
            -p 5055:5055 \
            -v $DOCKDATA_PATH/jellyseerr/config:/app/config \
            --restart unless-stopped \
            fallenbagel/jellyseerr:latest
        ;;
      *)
        echo "Unsupported item $WEBUISEL!" >&2
        exit 1
        ;;
      esac
    done
  fi

  # Download Clients

  if [ -z "$DOWNSEL" ]; then
    clear
    nosel
  else
    for DOWNSEL in $DOWNSEL; do
      case "$DOWNSEL" in
      "1")
        ## qBittorrent
        docker run -d \
          --name qbittorrent \
          -e PUID=$SID \
          -e PGID=$GUID \
          -e TZ=$TIMEZONE \
          -e WEBUI_PORT=8090 \
          -p 8090:8090 \
          -v $DOCKDATA_PATH/qbittorrent/appdata/config:/config \
          -v $DOCKDATA_PATH/qbittorrent/downloads:/downloads \
          -v $DATA_PATH/data:/data \
          --restart unless-stopped \
          linuxserver/qbittorrent:latest
        ;;
      "2")
        ## Deluge
        docker run -d \
            --name deluge \
            -e PUID=$SID \
            -e PGID=$GUID \
            -e TZ=$TIMEZONE \
            -e DELUGE_LOGLEVEL=error \
            -p 8112:8112 \
            -v $DOCKDATA_PATH/deluge/config:/config \
            -v $DOCKDATA_PATH/deluge/downloads:/downloads \
            --restart unless-stopped \
            linuxserver/deluge:latest    
        ;;
      "3")
        ## Transmission
        docker run -d \
            --name transmission \
            -e PUID=$SID \
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
        ;;
      *)
        echo "Unsupported item $DOWNSEL!" >&2
        exit 1
        ;;
      esac
    done
  fi

  # Additional Services

  if [ -z "$ADDSERSEL" ]; then
    clear
    nosel
  else
    for ADDSERSEL in $ADDSERSEL; do
      case "$ADDSERSEL" in
      "1")
        ## Bazarr
        docker run -d \
            --name bazarr \
            -e PUID=$SID \
            -e PGID=$GUID \
            -e TZ=$TIMEZONE \
            -p 6767:6767 \
            -v $DOCKDATA_PATH/bazarr/config:/config \
            -v $DATA_PATH:/data \
            --restart unless-stopped \
            linuxserver/bazarr:latest
        ;;
      "2")
        ## File Browser
        ### Creating DB
        mkdir -p $DOCKDATA_PATH/filebrowser/
        touch $DOCKDATA_PATH/filebrowser/filebrowser.db
        docker run \
            --name filebrowser \
            -e PUID=$SID \
            -e PGID=$GUID \
            -p 8070:80 \
            -v /:/srv \
            -v $DOCKDATA_PATH/filebrowser/filebrowser.db:/database/filebrowser.db \
            -v $DOCKDATA_PATH/filebrowser/settings.json:/config/settings.json \
            --restart unless-stopped \
            filebrowser/filebrowser:latest  
        ;;
      *)
        echo "Unsupported item $ADDSERSEL!" >&2
        exit 1
        ;;
      esac
    done
  fi

  # Server Dashboard

  if [ -z "$DASHSEL" ]; then
    clear
    nosel
  else
    for DASHSEL in $DASHSEL; do
      case "$DASHSEL" in
      "1")
        ## Heimdall
        docker run -d \
            --name heimdall \
            -e PUID=$SID \
            -e PGID=$GUID \
            -e TZ=$TIMEZONE \
            -p 80:80 \
            -p 443:443 \
            -v $DOCKDATA_PATH/heimdall:/config \
            --restart unless-stopped \
            linuxserver/heimdall:latest
        ;;
      "2")
        ## Organizr
        docker run -d \
            --name organizr \
            -e PUID=$SID \
            -e PGID=$GUID \
            -v $DOCKDATA_PATH/organizr:/config \
            -p 80:80 \
            -e fpm="false" \
            -e branch="v2-master" \
            organizr/organizr
        ;;
      "3")
        ## Dashy
        docker run -d \
            --name dashy \
            -p 80:80 \
            --restart=always \
            lissy93/dashy:latest
        ;;
      *)
        echo "Unsupported item $DASHSEL!" >&2
        exit 1
        ;;
      esac
    done
  fi

  # Monitoring

  if [ -z "$MONSEL" ]; then
    clear
    nosel
  else
    for MONSEL in $MONSEL; do
      case "$MONSEL" in
      "1")
        ## Cockpit
        . /etc/os-release
        sudo apt install -t ${VERSION_CODENAME}-backports cockpit
        ;;
      "2")
        ## Webmin
        wget http://prdownloads.sourceforge.net/webadmin/webmin_1.998_all.deb
        sudo dpkg --install webmin_1.998_all.deb
        ;;
      *)
        echo "Unsupported item $MONSEL!" >&2
        exit 1
        ;;
      esac
    done
  fi

}

## Services Removal Function
############# OPTIMIZE THIS ###################

function rmserv {
  # Removing Services ############# OPTIMIZE THIS ###################

  RMCONT=$(dialog --title "Select Services to remove." --separate-output --checklist "Choose using SPACE and next menu using ENTER" 10 35 4 \
    "1" "Heimdall" OFF \
    "2" "Organizr" OFF \
    "3" "Dashy" OFF \
    "4" "Cockpit" OFF \
    "5" "Portainer" OFF \
    "6" "Webmin" OFF \
    "7" "Prowlarr" OFF \
    "8" "Radarr" OFF \
    "9" "Sonarr" OFF \
    "10" "Jellyfin" OFF \
    "11" "Jellyseerr" OFF \
    "12" "Watchtower" OFF \
    "13" "Yacht" OFF \
    "14" "qBittorrent" OFF \
    "15" "Deluge" OFF \
    "16" "Transmission" OFF \
    "17" "Bazarr" OFF \
    "18" "Filebrowser" OFF 3>&1 1>&2 2>&3)
    clear

  if [ -z "$RMCONT" ]; then
    clear
    nosel
  else
    for RMCONT in $RMCONT; do
      case "$RMCONT" in
      "1")
        ## Heimdall
        docker stop heimdall
        docker rm heimdall
        ;;
      "2")
        ## Organizr
        docker stop organizr
        docker rm organizr
        ;;
      "3")
        ## Dashy
        docker stop dashy
        docker rm organizr
        ;;
      "4")
        ## Cockpit
        sudo apt-get -y autoremove cockpit --purge
        ;;
      "5")
        ## Portainer
        docker stop portainer
        docker rm portainer
        ;;
      "6")
        ## Webmin
        sudo apt-get -y --purge remove webmin
        ;;
      "7")
        ## Prowlarr
        docker stop prowlarr
        docker rm prowlarr
        ;;
      "8")
        ## Radarr
        docker stop radarr
        docker rm radarr
        ;;
      "9")
        ## Sonarr
        docker stop sonarr
        docker rm sonarr
        ;;
      "10")
        ## Jellyfin
        docker stop jellyfin
        docker rm jellyfin
        ;;
      "11")
        ## Jellyseerr
        docker stop jellyseerr
        docker rm jellyseerr
        ;;
      "12")
        ## Watchtower
        docker stop watchtower
        docker rm watchtower
        ;;
      "13")
        ## Yacht
        docker stop yacht
        docker rm yacht
        ;;
      "14")
        ## qBittorrent
        docker stop qbittorrent
        docker rm qbittorrent
        ;;
      "15")
        ## Deluge
        docker stop deluge
        docker rm deluge
        ;;
      "16")
        ## Transmission
        docker stop transmission
        docker rm transmission
        ;;
      "17")
        ## Bazarr
        docker stop bazarr
        docker rm bazarr
        ;;
      "18")
        ## FileBrowser
        docker stop filebrowser
        docker rm filebrowser
        ;;
      *)
        echo "Unsupported item $RMCONT!" >&2
        exit 1
        ;;
      esac
    done
  fi

}

## Configuration Menu 

function configmenu {
  CONFSEL=$(dialog --title "Configuration Menu" --menu "Choose an option" 18 100 10 \
    "Change Hostname" "Change Hostname of the server." \
    "Change Ports" "Change Ports of services and containers" \
    "Services Status" "View the status of services" \
    "Reset Ports to default" "Reset all Ports to default" \
    "Exit" "Exit configuration menu." 3>&1 1>&2 2>&3)

  if [ -z "$CONFSEL" ]; then
    nosel
  else
      if [[ "$CONFSEL" = "Change Ports" ]] ; then
          placeholder
      elif [[ "$CONFSEL" = "Change Hostname" ]] ; then
          hostn
      elif [[ "$CONFSEL" = "Reset Ports to default" ]] ; then
          placeholder
      elif [[ "$CONFSEL" = "Services Status" ]] ; then
          statusinfo
      elif [[ "$CONFSEL" = "Exit" ]] ; then
          exit
          clear
      fi
  fi

}

## Install Containers Function

function instcontainers {
  # Functions
  ## Indexers Selection
  indexPack
  ## Docker Monitoring
  docmon
  ## WebUI Selection
  webui
  ## Download Client Selection
  downui
  ## Additional Services Selection
  addserv
  ## Services Dashboard
  srvdash
  ## Server Monitoring Dashboard
  monitor
  ## Container Updater
  conupdate

}

## Custom Installation Menu

function custmenu {
  CUSTSEL=$(dialog --title "Custom Installation" --menu "Choose an option" 18 100 10 \
    "Indexers" "Choose Indexers and Aggregators. " \
    "UI" "Select Frontend UI." \
    "Docker Monitoring" "Select Docker monitoring service." \
    "Server Monitoring Dashboard" "View information and status of server." \
    "Download Clients" "Select Download Clients." \
    "Additional Services" "Select Additional Services." \
    "Services Dashboard" "Select services launcher dashboard." \
    "Container Updater" "Install automatic container updater." 3>&1 1>&2 2>&3)

  if [ -z "$CUSTSEL" ]; then
    nosel
  else
      if [[ "$CUSTSEL" = "Indexers" ]] ; then
          indexPack
      elif [[ "$CUSTSEL" = "UI" ]] ; then
          webui
      elif [[ "$CUSTSEL" = "Docker Monitoring" ]] ; then
          docmon
      elif [[ "$CUSTSEL" = "Server Monitoring Dashboard" ]] ; then
          monitor
      elif [[ "$CUSTSEL" = "Download Clients" ]] ; then
          downui
      elif [[ "$CUSTSEL" = "Additional Services" ]] ; then
          addserv
      elif [[ "$CUSTSEL" = "Services Dashboard" ]] ; then
          srvdash
      elif [[ "$CUSTSEL" = "Container Updater" ]] ; then
          conupdate
      fi

  fi
  clear
}

## Main Menu

function mainmenu {
  MENUSEL=$(dialog --title "Main Menu" --menu "Choose an option" 18 100 10 \
    "Run Installer" "Select and install containers and services" \
    "Remove Containers" "Select and remove installed containers and services" \
    "Custom Installation" "Show all options and choose specific services." \
    "Express Installation" "Express installation using default services and containers." \
    "Services Status" "View information and status of services and containers" \
    "Configuration" "Change ports of services." \
    "Exit" "Exit the Menu" 3>&1 1>&2 2>&3)

  if [ -z "$MENUSEL" ]; then
    nosel
  else
      if [[ "$MENUSEL" = "Run Installer" ]] ; then
          sysup
          depend
          gdepend
          instcontainers
          startinstall
          cleanup
      elif [[ "$MENUSEL" = "Remove Containers" ]] ; then
          rmserv
          cleanup
      elif [[ "$MENUSEL" = "Custom Installation" ]] ; then
          sysup
          depend
          gdepend
          custmenu
          cleanup
      elif [[ "$MENUSEL" = "Services Status" ]] ; then
          info
      elif [[ "$MENUSEL" = "Configuration" ]] ; then
          configmenu
      elif [[ "$MENUSEL" = "Exit" ]] ; then
          exit
      fi
  fi
}

## Flag Selector

while [ $# -gt 0 ]; do
  case $1 in
    -c|--cli)
      placeholder
      exit
      ;;
    -g|--graphical)
      gdepend
      mainmenu
      exit
      ;;
    -i|--info)
      gdepend
      info
      exit
      ;;
    -s|--status)
      statusinfo
      exit
      ;;
    -h|--help)
      help
      exit
      ;;
    *)
      echo "Unknown option $1"
      help
      exit 1
      ;;
  esac
done