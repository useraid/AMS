# Configurations

The services installed by `ams` needs to be configured to your own liking. You can find simple guides to set them up below and comprehensive documentation can be found on the respective websites for these services.
## <b>Setting up the services


## Contents
- [Indexers](#indexers)
    - [Prowlarr](#prowlarr)
    - [Radarr](#radarr)
    - [Sonarr](#sonarr)

- [Web UI](#b-web-ui))
    - [Jellyfin](#jellyfin)
    - [Jellyseerr](#jellyseerr)

- [Docker Monitoring](#b-docker-monitoring)
    - [Portainer](#portainer)
    - [Yacht](#yacht)

- [Download Clients](#b-download-clients)
    - [qBittorrent](#qbittorrent)
    - [Deluge](#deluge)
    - [Transmission](#transmission)

- [Server Dashboard](#b-server-dashboard)
    - [Cockpit](#cockpit)
    - [Webmin](#webmin)

- [Services Dashboard](#b-services-dashboard)
    - [Heimdall](#heimdall)
    - [Organizr](#organizr)
    - [Dashy](#dashy)

- [Additional Services](#b-additional-services)
    - [Filebrowser](#filebrowser)
    - [Bazarr](#bazarr)

- [Container Updater](#b-container-updater)
    - [Watchtower](#watchtower)




## <b> Indexers

## Prowlarr

Choose and add your favourite indexers using the + button and test the items added to the list using the test button on top right.

## Radarr

- Add the qBittorrent in the Download Clients tab.

## Sonarr

- Add the qBittorrent in the Download Clients tab.



## <b> Web UI

## Jellyfin

- Create an account (This is the default admin account)
- Add the media libraries from the administration dashboard.

## Jellyseerr

- Create an account (This is the default admin account)
- Add Sonarr and Radarr servers using their respective ports and ip addresses.
- Add different users with different permissions.



## <b> Docker Monitoring

## Portainer

- Create an account (This is the default admin account)
- You can manage the containers from here.

## Yacht

- Login using credentials : <br><i> User : `admin@yacht.local` Pass : `pass`</i>



## <b> Download Clients

## qBittorrent

- Login using credentials : <br><i> User - `admin` Pass - `adminadmin` </i>

## Deluge

- Login using credentials : <br><i> User - `admin` Pass - `deluge` </i>

## Transmission

- Login using credentials : <br><i> User - `admin` Pass - `adminpass` </i>



## <b> Server Dashboard

## Cockpit

- Login using your `root` account or any user account.

## Webmin

- Login using your `root` account or any user account.



## <b> Services Dashboard

## Heimdall

Add the services running on the docker containers with the format http://ip-addr:port. This will allow easier access to all the running containers without needing to put in the ip address and remembering different ports for different services.

## Organizr

You can create a user account from the settings.

Add the services running on the docker containers with the format http://ip-addr:port. This will allow easier access to all the running containers without needing to put in the ip address and remembering different ports for different services.

## Dashy

Add the services running on the docker containers with the format http://ip-addr:port. This will allow easier access to all the running containers without needing to put in the ip address and remembering different ports for different services.



## <b> Additional Services

## Filebrowser

This service would allow you to browse the root directory of the server.

## Bazarr

- Add Sonarr and Radarr api keys.
- Add the Providers (Recommended OpenSubtitles, SubScene)



## <b> Container Updater

## Watchtower

Watchtower will pull down a new image, gracefully shut down the existing container and restart it with the same options that were used when it was deployed initially. User doesn't need to change anything.