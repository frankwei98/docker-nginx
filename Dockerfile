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

####################OK Above###################Testing Below###################

#add user node and use it to install node/npm and run the app
RUN useradd --home /home/node -m -U -s /bin/bash node

#allow some limited sudo commands for user `node`
RUN echo 'Defaults !requiretty' >> /etc/sudoers; \
    echo 'node ALL= NOPASSWD: /usr/sbin/dpkg-reconfigure -f noninteractive tzdata, /usr/bin/tee /etc/timezone, /bin/chown -R node\:node /myapp' >> /etc/sudoers;

#run all of the following commands as user node from now on
USER node

RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.29.0/install.sh | bash

#change it to your required node version
ENV NODE_VERSION 5.1.1

#needed by nvm install
ENV NVM_DIR /home/node/.nvm

#install the specified node version and set it as the default one, install the global npm packages
RUN . ~/.nvm/nvm.sh && nvm install $NODE_VERSION && nvm alias default $NODE_VERSION && npm install -g bower forever --user "node"

#on container's boot the run script will update/install all required npm/bower packages for the app and run the app
ADD ./run_all.sh /run_all.sh

#exposes port 3000 but your app may use any port specified in it
EXPOSE 3000

#/run_all.sh does everything required on container's boot
CMD ["/bin/bash", "/run_all.sh"]

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
