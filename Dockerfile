FROM php:7.4.22-fpm

ENV UID=1000
ENV GID=1000

RUN mkdir -p /var/www/html

# Copy existing application directory contents
COPY . /var/www/html

# Set working directory
WORKDIR /var/www/html

RUN sed -i "s/user = www-data/user = root/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/group = www-data/group = root/g" /usr/local/etc/php-fpm.d/www.conf
RUN echo "php_admin_flag[log_errors] = on" >> /usr/local/etc/php-fpm.d/www.conf

# Install system dependencies
RUN apt update && apt install -y \
    zip  \
    curl  \
    unzip  \
    libzip-dev\
    libssh-dev \
    libjpeg-dev \
    libbz2-dev \
    libxml2-dev \
    libpng-dev \
    libonig-dev \
    libmcrypt-dev \
    libreadline-dev \
    libfreetype6-dev \
    libicu-dev \
    g++

# Clear cache
RUN apt clean && rm -rf /var/lib/apt/lists/*

# Pull NodeJs From REPO
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash

# Install NodeJs
RUN apt install nodejs

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install PHP extensions **(Redis will only work for PHP 8 within this block)
RUN docker-php-ext-install \
    gd \
    bz2 \
    intl \
    zip \
    exif \
    iconv \
    pcntl \
    bcmath \
    opcache \
    calendar \
    pdo \
    pdo_mysql \
    mbstring
# redis

RUN mkdir -p /usr/src/php/ext/redis \
    && curl -L https://github.com/phpredis/phpredis/archive/5.3.4.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 \
    && echo 'redis' >> /usr/src/php-available-exts \
    && docker-php-ext-install redis

USER root

CMD ["php-fpm", "-y", "/usr/local/etc/php-fpm.conf", "-R"]
