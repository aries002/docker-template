FROM php:5.6-apache

WORKDIR /var/www/html
# update dan upgrade
RUN rm /etc/apt/sources.list
RUN echo "deb [trusted=yes] http://archive.debian.org/debian/ stretch main" >> /etc/apt/sources.list
RUN echo "deb [trusted=yes] http://archive.debian.org/debian-archive/debian-security stretch/updates main" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y curl libcurl3-dev git

# install dependensi php
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