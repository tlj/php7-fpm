FROM ubuntu:16.04

MAINTAINER Thomas L. Johnsen <t.johnen@sportradar.com>

RUN apt-get update && \
    apt-get install -y software-properties-common curl && \
    add-apt-repository ppa:ondrej/php && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E5267A6C && \
    echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu xenial main" | tee /etc/apt/sources.list.d/ondrej-php.list && \ 
    curl https://packagecloud.io/gpg.key | apt-key add - && \
    echo "deb http://packages.blackfire.io/debian any main" | tee /etc/apt/sources.list.d/blackfire.list && \
    apt-get update && apt-get install -y \
      git \
      php7.1 \
      php7.1-cli \
      php7.1-curl \
      php7.1-fpm \
      php7.1-mysql \
      php7.1-intl \
      php7.1-dev \
      php7.1-xml \
      php7.1-mbstring \
      php7.1-zip \
      php-redis \
      php-xdebug \
      blackfire-agent \
      blackfire-php && \
    curl -so /bin/composer https://getcomposer.org/download/1.3.2/composer.phar && \
    chmod a+rx /bin/composer && \
    echo 'xdebug.remote_enable=on\n\
xdebug.remote_autostart=off\n\
xdebug.remote_port=8090\n\
xdebug.remote_handler=dbgp\n\
xdebug.remote_host=172.17.0.1\n\
xdebug.profiler_enable=off\n\
xdebug.profiler_output_dir=/var/www/var/profiler\n\
xdebug.profiler_enable_trigger=on' >> /etc/php/7.1/fpm/conf.d/20-xdebug.ini && \
    echo 'date.timezone = Europe/Berlin' >> /etc/php/7.1/fpm/conf.d/20-date.ini && \
    rm /etc/php/7.1/cli/conf.d/20-xdebug.ini /etc/php/7.1/cli/conf.d/90-blackfire.ini && \
    apt-get remove -y curl && \
    apt-get clean && \
    apt-get purge && \
    mkdir /run/php

COPY bin/* /bin/
COPY www.conf /etc/php/7.1/fpm/pool.d/www.conf

VOLUME ["/var/www"]

EXPOSE 9000

WORKDIR /var/www

ENTRYPOINT ["/bin/entrypoint.sh"]
