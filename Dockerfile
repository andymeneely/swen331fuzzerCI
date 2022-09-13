FROM vulnerables/web-dvwa:latest
FROM node:latest
FROM ruby:latest
FROM debian:11

RUN apt -y update --fix-missing

RUN apt -y install \
  autoconf \
  automake \
  bison \
  curl \
  g++ \
  gawk \
  gcc \
  libc6-dev \
  libffi-dev \
  libgdbm-dev \
  libncurses5-dev \
  libreadline6-dev \
  libsqlite3-dev \
  libssl-dev \
  libtool \
  libyaml-dev \
  make \
  patch \
  pkg-config \
  python3 \
  python3-pip \
  sqlite3 \
  vim \
  wget \
  zlib1g-dev


# rough smoke test
# RUN	ruby --version; \
# 	gem --version; \
# 	bundle --version 
# RUN node --version; \
# 	npm --version 


# install things globally, for great justice
# and don't create ".bundle" in all our apps
# ENV GEM_HOME /usr/local/bundle
# ENV BUNDLE_PATH="$GEM_HOME" \
# 	BUNDLE_SILENCE_ROOT_WARNING=1 \
# 	BUNDLE_APP_CONFIG="$GEM_HOME"
# # path recommendation: https://github.com/bundler/bundler/pull/6469#issuecomment-383235438
# ENV PATH $GEM_HOME/bin:$BUNDLE_PATH/gems/bin:$PATH
# # adjust permissions of a few directories for running "gem install" as an arbitrary user
# RUN mkdir -p "$GEM_HOME" && chmod 777 "$GEM_HOME"

# Install Fuzzer deps
RUN gem install mechanize
RUN pip3 install requests mechanicalsoup

# Add in our sample files
COPY badchars.txt /
COPY vectors.txt /
COPY words.txt /
RUN mkdir -p /var/www/html/fuzzer-tests
COPY fuzzer-tests /var/www/html/fuzzer-tests
