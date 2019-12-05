FROM php:7.4-fpm-alpine

ENV PHP_COMPOSER_VERSION 1.9.1
ENV PHP_SENDMAIL_HOST localhost
ENV PHP_SENDMAIL_PORT 1025
ENV PHP_OPCACHE_ENABLE 1
ENV PHP_DEBUG_ENABLE 0
ENV PHP_XDEBUG_ENABLE $PHP_DEBUG_ENABLE

# Install persistant dependencies and utilities.
RUN apk add --update --no-cache \
        ca-certificates \
        imagemagick \
        icu-libs \
        msmtp \
        libmemcached-libs \
        libzip \
        zlib

# Install temporary build tools and PHP extensions.
RUN apk add --update --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        curl \
        curl-dev \
        freetype-dev \
        icu-dev \
        imagemagick-dev \
        libc-dev \
        libmemcached-dev \
        libpng-dev \
        libjpeg-turbo-dev \
        libzip-dev \
        zlib-dev \
    \
    && pecl install \
        igbinary \
        imagick \
        xdebug \
        redis \
        memcached \
    \
    && docker-php-ext-enable \
        igbinary \
        imagick \
        xdebug \
        redis \
        memcached \
    \
    && docker-php-ext-install -j "$(nproc)" \
        bcmath \
        exif \
        gd \
        mysqli \
        opcache \
        zip \
    \
    && curl -sS https://getcomposer.org/installer | php -- \
        --version=$PHP_COMPOSER_VERSION \
        --install-dir=/usr/local/bin \
        --filename=composer \
    \
    && rm -rf /tmp/* \
    && apk del .build-deps

COPY config/php/* /usr/local/etc/php/conf.d/

CMD ["php-fpm"]