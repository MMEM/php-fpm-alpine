## See Dockerfile
FROM php:8.4-fpm-alpine

RUN set -xe \
    && apk add --update icu \
    && apk add --no-cache --virtual .deps make icu-dev g++ libtool build-base $PHPIZE_DEPS \
    && apk add --no-cache libmcrypt-dev \
    && yes | pecl install -o -f mcrypt-1.0.9 \
    && docker-php-ext-enable mcrypt \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install opcache \
    && docker-php-ext-install pdo \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    && docker-php-ext-enable intl \
    && pecl download mailparse-3.1.8 && tar -xvf mailparse-3.1.8.tgz  && cd mailparse-3.1.8/ && phpize \
    && ./configure \
    && sed -i 's/#if\s!HAVE_MBSTRING/#ifndef MBFL_MBFILTER_H/' ./mailparse.c \
    && make \
    && make install \
    && echo "extension=mailparse.so" > /usr/local/etc/php/conf.d/30-mailparse.ini \
    && { find /usr/local/lib -type f -print0 | xargs -0r strip --strip-all -p 2>/dev/null || true; } \
    && apk del .deps \
    && rm -rf /tmp/* /usr/local/lib/php/doc/* /var/cache/apk/*

COPY ./laravel.ini  /usr/local/etc/php/conf.d
COPY ./xlaravel.pool.conf /usr/local/etc/php-fpm.d/

WORKDIR /var/www

CMD ["php-fpm"]

EXPOSE 9000
