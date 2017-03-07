#!/bin/bash

if [[ ! -z "${BSA_PHP_NO_XDEBUG}" ]]; then
    rm /etc/php/7.1/fpm/conf.d/20-xdebug.ini
fi

if [[ ! -z "${BLACKFIRE_SERVER_TOKEN}" && ! -z "${BLACKFIRE_SERVER_ID}" && ! $(grep ${BLACKFIRE_SERVER_ID} /etc/blackfire/agent) ]]; then
    echo "Starting blackfire..."
    sed -i "s/^server-id=.*$/server-id=${BLACKFIRE_SERVER_ID}/" /etc/blackfire/agent
    sed -i "s/^server-token=.*$/server-token=${BLACKFIRE_SERVER_TOKEN}/" /etc/blackfire/agent
    service blackfire-agent start
fi

if [ -d /var/www/var ]; then
  chown -R www-data:www-data /var/www/var
fi

php-fpm7.1 -F
