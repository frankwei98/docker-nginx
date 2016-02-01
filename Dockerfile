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
RUN apt-get -y install node-gyp nodejs npm node

# Download Ghost
RUN \
  cd /home  && \
  mkdir node  && \
  cd node  && \
  wget http://dl.ghostchina.com/Ghost-0.7.4-zh-full.zip  && \
  unzip Ghost-0.7.4-zh-full.zip  && \
  mv config.example.js config.js

# Install Ghost
RUN chmod a+x /start.sh
add . /
RUN npm install

CMD ['/start.sh']

# Define working directory.
WORKDIR /home/node
