FROM php:7.4-fpm

# curl for cmd
RUN apt update && apt install -y curl procps

# -------------------- Installing PHP Extension: zip --------------------
RUN set -eux \
    # Installation: Generic
    # Type:         Built-in extension
    && apt install -y libzip-dev \
    && docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) zip \
    && true

# -------------------- Delete extracted php source --------------------
RUN set -eux \
    && docker-php-source delete \
    && true

# Enable php fpm status page
RUN set -xe && echo "pm.status_path = /status" >> /usr/local/etc/php-fpm.d/zz-docker.conf

RUN set -eux \
    && curl https://raw.githubusercontent.com/renatomefi/php-fpm-healthcheck/master/php-fpm-healthcheck > /usr/local/bin/php-fpm-healthcheck \
    && chmod +x /usr/local/bin/php-fpm-healthcheck \
#    && apt install -y libfcgi-bin \
    && true

###
### Envs
###
ENV MY_USER="app" \
    MY_GROUP="app"

ARG DOCKER_UID=1000
ARG DOCKER_GID=1000

###
### User/Group
###
RUN set -eux \
	&& groupadd -g ${DOCKER_GID} -r ${MY_GROUP} \
	&& useradd -d /home/${MY_USER} -u ${DOCKER_UID} -m -s /bin/bash -g ${MY_GROUP} ${MY_USER}


###
### Copy files
###
###
COPY ./data/php.ini /usr/local/etc/php/conf.d/default-php.ini
COPY ./data/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./data/global.conf /usr/local/etc/php-fpm.d/global.conf

RUN touch /usr/local/etc/php-fpm.d/env.conf
RUN chown ${MY_USER}:${MY_GROUP} /usr/local/etc/php-fpm.d/env.conf


###
### Verify
###
RUN set -eux \
    && echo "date.timezone=UTC" > /usr/local/etc/php/php.ini \
    && php -v | grep -oE 'PHP\s[.0-9]+' | grep -oE '[.0-9]+' | grep '^7.4' \
    && /usr/local/sbin/php-fpm --test \
    \
    && PHP_ERROR="$( php -v 2>&1 1>/dev/null )" \
    && if [ -n "${PHP_ERROR}" ]; then echo "${PHP_ERROR}"; false; fi \
    && PHP_ERROR="$( php -i 2>&1 1>/dev/null )" \
    && if [ -n "${PHP_ERROR}" ]; then echo "${PHP_ERROR}"; false; fi \
    \
    && PHP_FPM_ERROR="$( php-fpm -v 2>&1 1>/dev/null )" \
    && if [ -n "${PHP_FPM_ERROR}" ]; then echo "${PHP_FPM_ERROR}"; false; fi \
    && PHP_FPM_ERROR="$( php-fpm -i 2>&1 1>/dev/null )" \
    && if [ -n "${PHP_FPM_ERROR}" ]; then echo "${PHP_FPM_ERROR}"; false; fi \
    && rm -f /usr/local/etc/php/php.ini

