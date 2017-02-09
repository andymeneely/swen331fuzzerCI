FROM php:7.0-apache
RUN apt-get -y update
RUN apt-get -y install \
  ruby-full \
  ruby-dev \
  zlib1g-dev \
  liblzma-dev \
  build-essential \
  patch \
  libgmp-dev \
  pkg-config \
  libxslt \
  libxml2
RUN gem install nokogiri
