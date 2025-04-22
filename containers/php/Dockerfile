FROM php:8.4-fpm

LABEL maintainer="Munzambi Miguel <munzambi.miguel@email.com>"

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC
ENV TERM=xterm
ENV COMPOSER_HOME=/root/.config/composer
ENV PATH="/root/.config/composer/vendor/bin:$PATH"

# Ajusta o timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Instala dependências básicas
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev \
    libpq-dev libzip-dev zlib1g-dev \
    unixodbc-dev gnupg2 lsb-release \
    libldap2-dev curl unzip git \
    supervisor nano lsof libcap2-bin \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Instala cliente do SQL Server
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql17

# Instala extensões PHP
RUN pecl install pdo_sqlsrv && docker-php-ext-enable pdo_sqlsrv \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd zip pdo pdo_mysql ldap

# Instala Node.js, Yarn, pnpm, bun
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /usr/share/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" > /etc/apt/sources.list.d/nodesource.list \
    && apt-get update && apt-get install -y nodejs \
    && npm install -g npm pnpm bun \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor -o /usr/share/keyrings/yarn.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/yarn.gpg] https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
    && apt-get update && apt-get install -y yarn

# Instala o Composer
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

# Instala Laravel Installer globalmente
RUN composer global require laravel/installer

# Permitir PHP rodar na porta 80 se necessário
RUN setcap "cap_net_bind_service=+ep" /usr/local/bin/php

# Define o diretório de trabalho
WORKDIR /var/www/html

# Prepara o diretório da aplicação
RUN mkdir -p /var/www/html/vendor && chown -R www-data:www-data /var/www/html


# Expõe a porta padrão do PHP-FPM
EXPOSE 9000

# Entrypoint padrão
CMD ["php-fpm"]
