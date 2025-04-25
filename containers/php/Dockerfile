FROM php:8.4-fpm-alpine

LABEL maintainer="Munzambi Miguel <munzambi.miguel@email.com>"

ENV COMPOSER_HOME="/root/.config/composer" \
    PATH="/root/.config/composer/vendor/bin:$PATH" \
    TZ="UTC"

dtrt

# Instala dependências básicas + PHP extensions
RUN apk add --no-cache \
    bash curl git unzip \
    libpng-dev libjpeg-turbo-dev freetype-dev \
    libzip-dev oniguruma-dev icu-dev \
    zlib-dev

# Configura extensões PHP
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd zip pdo pdo_mysql intl

# Instala Composer e Laravel Installer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    composer global require laravel/installer

# Instala Node.js (com npm)
RUN apk add --no-cache nodejs npm

# Diretório da aplicação
WORKDIR /var/www/html

# Permissão (ajustável conforme seu ambiente)
RUN chown -R www-data:www-data /var/www/html

RUN apk add --no-cache mysql-client

# Expõe porta PHP-FPM
EXPOSE 9000

CMD ["php-fpm"]
