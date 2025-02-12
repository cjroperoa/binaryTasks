# Copyright 2025 Cristian Ropero
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM php:5.3-apache

ENV DEBIAN_FRONTEND=noninteractive

# repo Debian Jessie (obsolete, necesary for PHP 5.3)
RUN echo 'deb http://archive.debian.org/debian jessie main' > /etc/apt/sources.list && \
    echo 'deb http://archive.debian.org/debian-security jessie/updates main' >> /etc/apt/sources.list && \
    echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid-until && \
    apt-get update --fix-missing && \
    apt-get install -y --allow-unauthenticated \
    php5-mysql php5-gd php5-curl php5-cli unzip wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# config Apache 
RUN echo '<VirtualHost *:80>\n\
    DocumentRoot /var/www/html\n\
    ServerName localhost\n\
    <Directory /var/www/html>\n\
        Options FollowSymLinks\n\
        AllowOverride All\n\
        Require all granted\n\
    </Directory>\n\
</VirtualHost>' > /etc/apache2/sites-available/000-default.conf

# config global servername
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# enabling URL rewriting
RUN a2enmod rewrite

# config timezone
RUN mkdir -p /etc/php5/apache2/conf.d && \
    echo "date.timezone = 'UTC'" > /etc/php5/apache2/conf.d/99-timezone.ini

# PHPUnit 4.8.36 (obsolete, necesary for PHP 5.3)
RUN wget https://phar.phpunit.de/phpunit-4.phar -O /usr/local/bin/phpunit && \
    chmod +x /usr/local/bin/phpunit

# project code
COPY src/ /var/www/html/
RUN chown -R www-data:www-data /var/www/html/

EXPOSE 80

CMD ["apache2ctl", "-D", "FOREGROUND"]
