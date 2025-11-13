FROM wordpress:php8.2-fpm
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg62-turbo-dev libfreetype6-dev libzip-dev zip unzip nano \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip mysqli \
    && docker-php-ext-enable mysqli
COPY wp.ini /usr/local/etc/php/conf.d/wp.ini
