FROM php:7.4-apache

WORKDIR /var/www/html

# rubah repo ke srchive.debian.org
RUN rm /etc/apt/sources.list
RUN echo "deb http://archive.debian.org/debian bullseye main" >> /etc/apt/sources.list
RUN echo "deb http://archive.debian.org/debian-security bullseye-security main" >> /etc/apt/sources.list
RUN echo "deb http://archive.debian.org/debian bullseye-updates main" >> /etc/apt/sources.list

# update dan upgrade paket
RUN apt update
RUN apt upgrade -y --fix-missing

# install dependensi php
RUN apt install -y curl libcurl3-dev git libonig-dev
RUN docker-php-ext-install curl
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install mbstring

# install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === 'c8b085408188070d5f52bcfe4ecfbee5f727afa458b2573b8eaaf77b3419b0bf2768dc67c86944da1544f06fa544fd47') { echo 'Installer verified'.PHP_EOL; } else { echo 'Installer corrupt'.PHP_EOL; unlink('composer-setup.php'); exit(1); }"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer

EXPOSE 80