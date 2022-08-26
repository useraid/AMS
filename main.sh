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

        -s|--selective           Choose which services, containers and programs to Use.

        -r|--remove-all          Remove all Services, Programs and Containers.

        -x|--selective-remove    Choose which services, containers and programs to remove.

        -g|--graphical           Use Terminal Based GUI to setup.
                                (Pending Implementation)
EOF
}

## Graphical 
function graphical {
  dialog --backtitle "GUI Configuration" \
      --title "GUI Configuration" --infobox "The GUI implementation is still a work in progress. Check the repository for progress on these feature." 10 30
}

## Dependencies
function depend {
  sudo apt-get -y install dialog

  # Installing Docker-CE
  curl -fsSL https://get.docker.com -o get-docker.sh
  sh get-docker.sh
}

## Flag Selector
while [ $# -gt 0 ]; do
  case $1 in
    -a|--install-all)
      help
      exit
      ;;
    -s|--selective)
      help
      exit
      ;;
    -r|--remove-all)
      help
      exit
      ;;
    -x|--selective-remove)
      help
      exit
      ;;
    -h|--help)
      help
      exit
      ;;
    -g|--graphical)
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