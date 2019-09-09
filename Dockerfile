
FROM tutum/lamp:latest

RUN apt-get -y update --fix-missing
RUN apt-get -y install \
  automake \
  bison \
  build-essential \
  curl \
  gawk \
  libffi-dev \
  libgdbm-dev \
  libgmp-dev \
  liblzma-dev \
  libncurses5-dev \
  libreadline6-dev \
  libsqlite3-dev \
  libssl-dev \
  libyaml-dev \
  libtool \
  patch \
  php5-gd \
  pkg-config \
  python \
  python3 \
  python-pip \
  python3-pip \
  sqlite3 \
  vim \
  wget \
  zlib1g-dev

#Install Node
#https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions
RUN curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
RUN apt-get install -y nodejs

# Install DVWA
RUN rm -fr /app && git clone https://github.com/ethicalhack3r/DVWA /app
RUN sed -i -e "s/AllowOverride FileInfo/AllowOverride FileInfo Options/" /etc/apache2/sites-enabled/000-default.conf
RUN sed -i -e "s/allow_url_include = Off/allow_url_include = On/" /etc/php5/apache2/php.ini
RUN cp /app/config/config.inc.php.dist /app/config/config.inc.php
RUN sed -i -e 's/root/admin/' /app/config/config.inc.php
RUN chmod 777 /app/hackable/uploads
RUN chmod 777 /app/external/phpids/0.6/lib/IDS/tmp/phpids_log.txt

# Install Ruby from source
RUN wget https://cache.ruby-lang.org/pub/ruby/2.6/ruby-2.6.4.tar.bz2
RUN tar -xzvf ruby-2.6.4.tar.bz2 \
  && cd ruby-2.6.4 \
  && ./configure \
  && make \
  && make install
RUN ruby -v

# Add in our sample files

COPY vectors.txt /
COPY words.txt /
COPY badchars.txt /

# Install Fuzzer deps
RUN gem install mechanize

#test node
RUN node --version
RUN npm --version

CMD ["/run.sh"]
