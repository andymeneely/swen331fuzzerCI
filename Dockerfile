FROM php:7.0-apache
RUN apt-get -y update
RUN apt-get -y install \
  build-essential \
  libgmp-dev \
  liblzma-dev \
  patch \
  pkg-config \
  python \
  python3 \
  ruby-dev \
  ruby-full \
  zlib1g-dev
RUN gem install mechanize
