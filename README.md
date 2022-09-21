# AMS

<p align="right"><a href="https://hits.seeyoufarm.com"><img src="https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Fuseraid%2FAMS&count_bg=%23262B22&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=hits&edge_flat=false"/></a></p>

![New Project](https://user-images.githubusercontent.com/93074700/191500641-70210a97-bc0a-4a6e-b1e6-f2d9deeb28d0.png)

AMS allows you to create a Media Server running services as docker containers.

## Quick Setup

### Clone the repository
```
git clone https://github.com/useraid/AMS.git
```
### Build the debian package
```
chmod +x build.sh
./build.sh
```
### Install the Package
Download the `deb` package from the releases and install it using `dpkg`.
```
sudo dpkg -i ams*.deb
```
## Documentation 

You can find the Documentation in the wiki or [here.](/Docs/)

## Contribution

Before contributing, go through the [Contribution Guide](/CONTRIBUTING.md). This will allow you to have a better chance at a successful PR/Contribution.