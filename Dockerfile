FROM ubuntu:14.04
MAINTAINER Frank Wei <franciswei98@gmail.com>

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

# Update System
RUN apt-get -y update

# Install some necessary software
RUN apt-get install -y make gcc wget software-properties-common

# Install Nginx.
RUN \
  add-apt-repository -y ppa:nginx/stable && \
  apt-get update && \
  apt-get install -y nginx && \
  rm -rf /var/lib/apt/lists/* && \
  echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
  chown -R www-data:www-data /var/lib/nginx

# Define mountable directories.
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html"]

# Define nginx working directory.
WORKDIR /etc/nginx

# Define default command.
CMD ["nginx"]

# Expose ports.
EXPOSE 80
EXPOSE 443


# Install Node.js by using NVM
RUN \
  wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.30.1/install.sh | bash
  nvm install 4.2.4
  nvm use 4.2.4


# Define working directory.
WORKDIR /data

# Download Ghost
RUN \
  cd /home  && \
  mkdir node  && \
  cd node  && \
  wget http://dl.ghostchina.com/Ghost-0.7.4-zh-full.zip  && \
  unzip Ghost-0.7.4-zh-full.zip  && \
  mv config.example.js config.js

# Define working directory.
WORKDIR /home/node
  
CMD ["npm start"]
