FROM ubuntu
RUN mkdir /AMS
RUN apt-get -y update
RUN apt-get install -y dialog
RUN apt-get install -y git
RUN apt-get install -y curl
COPY . /AMS