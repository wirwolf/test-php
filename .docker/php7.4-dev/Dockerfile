ARG DOCKER_IMAGE_VERSION=master
ARG DOCKER_SERVER_HOST
ARG DOCKER_PROJECT_PATH
ARG DOCKER_PHP_VERSION

FROM ${DOCKER_SERVER_HOST}/${DOCKER_PROJECT_PATH}/php${DOCKER_PHP_VERSION}-composer:${DOCKER_IMAGE_VERSION}

## -------------------- Installing PHP Extension: xdebug --------------------
RUN set -eux \
    # Installation: Generic
    # Type:         PECL extension
    # Default:      Pecl command
    && pecl channel-update pecl.php.net \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && true


RUN apt update && apt install -y bash-completion

RUN apt update && apt install -y telnet nmap

ADD xxx-develop-php.ini /usr/local/etc/php/conf.d/xxx-develop-php.ini


WORKDIR /app