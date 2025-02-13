FROM php:8.1-apache
RUN a2enmod rewrite

# Postgres PDO y varios
RUN apt-get update && apt-get install -y libxml2-dev libpq-dev libzip-dev mc zip unzip git curl gnupg \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install \
      pdo \
      pdo_pgsql \
      pgsql \
      zip \
      soap \
      bcmath \
      calendar

RUN apt-get update && apt-get install -y \
    libxslt1-dev \
    && docker-php-ext-install xsl \
    && docker-php-ext-enable xsl

RUN CPPFLAGS="-DHAVE_SYS_FILE_H" pecl install dbase \
  && docker-php-ext-enable dbase

# yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -y yarn

# necesarios para gd
RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  libfreetype6-dev \
  libjpeg62-turbo-dev \
  libpng-dev \
  && rm -rf /var/lib/apt/lists/*
# gd
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
  && docker-php-ext-install -j "$(nproc)" gd 

# composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer self-update

# Instalar phpCAS
RUN curl -L -o /tmp/phpCAS.tar.gz https://github.com/apereo/phpCAS/archive/refs/tags/1.6.0.tar.gz \
    && mkdir -p /usr/src/phpCAS \
    && tar -xzf /tmp/phpCAS.tar.gz -C /usr/src/phpCAS --strip-components=1 \
    && rm /tmp/phpCAS.tar.gz

# Instalar SimpleSAMLphp
RUN curl -L -o /tmp/simplesamlphp.tar.gz https://github.com/simplesamlphp/simplesamlphp/releases/download/v2.0.7/simplesamlphp-2.0.7.tar.gz \
    && mkdir -p /var/www/simplesamlphp \
    && tar -xzf /tmp/simplesamlphp.tar.gz -C /var/www/simplesamlphp --strip-components=1 \
    && rm /tmp/simplesamlphp.tar.gz

# Instalar Securimage
RUN curl -L -o /tmp/securimage.zip https://github.com/dapphp/securimage/archive/refs/heads/master.zip \
    && mkdir -p /var/www/securimage \
    && unzip /tmp/securimage.zip -d /var/www/securimage \
    && rm /tmp/securimage.zip

# creamos workdir y le damos permisos
RUN mkdir -p /data/local && chown -R www-data:www-data /data/local && chmod -R 777 /data/local

EXPOSE 80

WORKDIR /data/local

# cambiando el UID al apache
RUN sed -e 's/:33:33:/:1000:1000:/' -i /etc/passwd
RUN sed -e 's/:33/:1000/' -i /etc/group

#Se pasa el access.log a archivo
RUN sed -i 's|/proc/self/fd/1|/var/log/apache2/access.log|' /etc/apache2/apache2.conf
#Se pasa el error.log a stdout, para que salga en el log de docker
RUN sed -i 's|/proc/self/fd/2|/proc/self/fd/1|' /etc/apache2/apache2.conf

COPY start.sh /entrypoint-dir/start.sh

RUN chmod +x /entrypoint-dir/start.sh

ENTRYPOINT ["/entrypoint-dir/start.sh"]