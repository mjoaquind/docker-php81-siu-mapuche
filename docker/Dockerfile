FROM php:8.1-apache

# Habilitar mod_rewrite
RUN a2enmod rewrite

# Instalar dependencias en una sola capa
RUN apt-get update && apt-get install -y --no-install-recommends \
    libxml2-dev libpq-dev libzip-dev mc zip unzip git curl gnupg \
    libxslt1-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev yarn \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_pgsql pgsql zip soap bcmath calendar xsl gd \
    && docker-php-ext-enable xsl \
    && rm -rf /var/lib/apt/lists/*

# Instalar composer sin auto-update
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Instalar phpCAS
RUN curl -L -o /usr/local/src/phpCAS.tar.gz https://github.com/apereo/phpCAS/archive/refs/tags/1.6.0.tar.gz \
    && mkdir -p /usr/src/phpCAS \
    && tar -xzf /usr/local/src/phpCAS.tar.gz -C /usr/src/phpCAS --strip-components=1 \
    && rm /usr/local/src/phpCAS.tar.gz

# Instalar SimpleSAMLphp
RUN curl -L -o /usr/local/src/simplesamlphp.tar.gz https://github.com/simplesamlphp/simplesamlphp/releases/download/v2.0.7/simplesamlphp-2.0.7.tar.gz \
    && mkdir -p /var/www/simplesamlphp \
    && tar -xzf /usr/local/src/simplesamlphp.tar.gz -C /var/www/simplesamlphp --strip-components=1 \
    && rm /usr/local/src/simplesamlphp.tar.gz

# Instalar Securimage
RUN mkdir -p /usr/local/src/securimage \
    && curl -L -o /usr/local/src/securimage.zip https://github.com/dapphp/securimage/archive/refs/heads/master.zip \
    && unzip /usr/local/src/securimage.zip -d /var/www/securimage \
    && rm /usr/local/src/securimage.zip

# Crear workdir y asignar permisos en una sola capa
RUN mkdir -p /data/local \
    && chown -R www-data:www-data /data/local \
    && chmod -R 777 /data/local

# Cambiar UID de Apache
RUN sed -i -e 's/:33:33:/:1000:1000:/' -e 's/:33/:1000/' /etc/passwd \
    && sed -i -e 's/:33/:1000/' /etc/group

# Configuración de logs de Apache
RUN sed -i -e 's|/proc/self/fd/1|/var/log/apache2/access.log|' \
           -e 's|/proc/self/fd/2|/proc/self/fd/1|' /etc/apache2/apache2.conf

# Copiar y dar permisos al script de entrada en una sola capa
COPY start.sh /entrypoint-dir/start.sh
RUN chmod +x /entrypoint-dir/start.sh

# Exponer el puerto 80
EXPOSE 80

# Establecer el directorio de trabajo
WORKDIR /data/local

# Definir el punto de entrada
ENTRYPOINT ["/entrypoint-dir/start.sh"]