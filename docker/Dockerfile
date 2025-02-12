FROM php:8.1-apache
RUN a2enmod rewrite

# Postgres PDO y varios
RUN apt-get update && apt-get install -y libxml2-dev libpq-dev libzip-dev mc git git-flow gnupg \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql pgsql zip soap

# zsh
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

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
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# creamos workdir y le damos permisos
RUN mkdir -p /data/local && chown -R www-data:www-data /data/local && chmod -R 777 /data/local

EXPOSE 80

WORKDIR /data/local

COPY docker/sistema/start.sh /entrypoint-dir/start.sh

RUN chmod +x /entrypoint-dir/start.sh

ENTRYPOINT ["/entrypoint-dir/start.sh"]