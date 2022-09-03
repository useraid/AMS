# Report issues
If you have any issue with AMS, sorry about that, I'll try to solve it asap. It would be better if you try to reinstall the program from the latest release and see if the bug is fixed.

If it is, check if the problem has not already been reported and
if not, just open an issue on [GitHub](https://github.com/useraid/AMS) with
the following basic information:
  - the output of `ams --version` .
  - your shell and its version (`bash`, `zsh`);
  - your system (Preferably Name from os-release);
  - how to reproduce the bug;
  - anything else you think is relevant.

It's only with enough information that I can do something to fix the problem.

# Make a pull request
I'll gladly accept pull request on the [official
repository](https://github.com/useraid/AMS) for new rules, new features, bug
fixes, etc.

# Developing

In order to develop locally, It would be better to setup a VM or a Container.

## Develop using Virtual Machine

- [Create a Debian VM in VMware.](https://www.sysnettechsolutions.com/en/install-debian-vmware/)

- [Create a Debian VM in Virtualbox.](https://www.sysnettechsolutions.com/en/install-debian-virtualbox/)

## Develop using Ubuntu Container

A Dockerfile is added in the repository with preinstalled dependencies and tools. You can build and deploy it using docker cli.


### Prerequisites

To use the container you require:
- [Docker](https://www.docker.com/products/docker-desktop)
- [VSCode](https://code.visualstudio.com/)
- [VSCode Remote Development Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack)
- [Windows Users Only]: [Installation of WSL2 and configuration of Docker to use it](https://docs.docker.com/docker-for-windows/wsl/)

Full notes about [installation are here](https://code.visualstudio.com/docs/remote/containers#_installation)

### Running the container

Assuming you have the prerequisites and you `git clone` into home. :

1. Change Directory (`cd`) into the repository.
```
cd ~/AMS
```
2. Build the Custom Ubuntu Image.
```
docker build -t amsdev .
```
3. Initialize and Run the container using the newly built image.
```
docker run -dit --name amsdev amsdev
```
4. Open the container in VSCode and develop in the container.