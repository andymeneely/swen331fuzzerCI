
FROM ubuntu:trusty
RUN echo "hello world"
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
  sqlite3 \
  vim \
  wget \
  zlib1g-dev

RUN  apt-get -y install supervisor git apache2 libapache2-mod-php5 mysql-server php5-mysql pwgen php-apc php5-mcrypt && \
  echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Add image configuration and scripts
ADD start-apache2.sh /start-apache2.sh
ADD start-mysqld.sh /start-mysqld.sh

ADD run.sh /run.sh
RUN chmod 755 /*.sh
ADD my.cnf /etc/mysql/conf.d/my.cnf
ADD supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf
ADD supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf

# Remove pre-installed database
RUN rm -rf /var/lib/mysql/*

# Add MySQL utils
ADD create_mysql_admin_user.sh /create_mysql_admin_user.sh
RUN chmod 755 /*.sh

# config to enable .htaccess
ADD apache_default /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

# Configure /app folder with sample app
RUN git clone https://github.com/fermayo/hello-world-lamp.git /app
RUN mkdir -p /app && rm -fr /var/www/html && ln -s /app /var/www/html

#Environment variables to configure php
ENV PHP_UPLOAD_MAX_FILESIZE 10M
ENV PHP_POST_MAX_SIZE 10M

# Add volumes for MySQL
VOLUME  ["/etc/mysql", "/var/lib/mysql" ]

# Install DVWA
RUN rm -fr /app && git clone https://github.com/RandomStorm/DVWA /app
RUN sed -i -e "s/AllowOverride FileInfo/AllowOverride FileInfo Options/" /etc/apache2/sites-enabled/000-default.conf
RUN sed -i -e "s/allow_url_include = Off/allow_url_include = On/" /etc/php5/apache2/php.ini
RUN sed -i -e 's/root/admin/' /app/config/config.inc.php
RUN chmod 777 /app/hackable/uploads
RUN chmod 777 /app/external/phpids/0.6/lib/IDS/tmp/phpids_log.txt

# Install Ruby from source
RUN wget http://ftp.ruby-lang.org/pub/ruby/2.3/ruby-2.3.3.tar.gz
RUN tar -xzvf ruby-2.3.3.tar.gz \
  && cd ruby-2.3.3 \
  && ./configure \
  && make \
  && make install
RUN ruby -v

# Install Fuzzer deps
RUN gem install mechanize

ADD dvwaDBsetup.sql /dvwaDBsetup.sql
RUN chmod 777 /dvwaDBsetup.sql
ADD mysql-setup.sh /mysql-setup.sh
RUN chmod 777 /mysql-setup.sh
RUN rm /app/config/config.inc.php
ADD config.inc.php /app/config/config.inc.php

EXPOSE 80 3306
CMD ["/run.sh"]
