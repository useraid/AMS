#!/bin/bash
url=""
websites_list=":8096 :9000 :8989 :7878 :8090 :5055"
curl -H "Content-Type: application/json" -X POST -d '{"content":"'" Sat Aug 27 13:56:17 IST 2022 \n***Services*** "'"}'  
for website in  ; do
        status_code=

        if [[ "" -ne 200 ]] ; then
            if [[ "" = http://*.*.*.*:8096 ]] ; then
                domain="Jellyfin"
            elif [[ "" = http://*.*.*.*:9000 ]] ; then
                domain="Portainer"
            elif [[ "" = http://*.*.*.*:8989 ]] ; then
                domain="Sonarr"
            elif [[ "" = http://*.*.*.*:7878 ]] ; then
                domain="Radarr"
            elif [[ "" = http://*.*.*.*:8090 ]] ; then
                domain="qBittorrent"
            elif [[ "" = http://*.*.*.*:5055 ]] ; then
                domain="Jellyseerr"
            fi
            curl -H "Content-Type: application/json" -X POST -d '{"content":"'" is down with SC : "'"}'  
        else
            if [[ "" = http://*.*.*.*:8096 ]] ; then
                domain="Jellyfin"
            elif [[ "" = http://*.*.*.*:9000 ]] ; then
                domain="Portainer"
            elif [[ "" = http://*.*.*.*:8989 ]] ; then
                domain="Sonarr"
            elif [[ "" = http://*.*.*.*:7878 ]] ; then
                domain="Radarr"
            elif [[ "" = http://*.*.*.*:8090 ]] ; then
                domain="qBittorrent"
            elif [[ "" = http://*.*.*.*:5055 ]] ; then
                domain="Jellyseerr"
            fi
            curl -H "Content-Type: application/json" -X POST -d '{"content":"'" is up and running with SC : "'"}'  
        fi
done
