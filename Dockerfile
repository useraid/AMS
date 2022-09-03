FROM ubuntu
RUN apt-get -y update
RUN apt install -y dialog
RUN apt install -y git
RUN apt install -y curl
COPY . .