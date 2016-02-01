FROM ubuntu:14.04
MAINTAINER Frank Wei <franciswei98@gmail.com>

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

# Update System
RUN apt-get -y update

# Install some necessary software and nginx
RUN apt-get install -y make gcc wget
RUN apt-get install -y nginx
