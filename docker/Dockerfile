FROM php:8.1-apache

# Habilitar mod_rewrite
RUN a2enmod rewrite

# Instalar dependencias del sistema y extensiones PHP
RUN apt-get update && apt-get install -y --no-install-recommends \
    libxml2-dev libpq-dev libzip-dev mc zip unzip git curl gnupg \
    libxslt1-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev \
    libonig-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_pgsql pgsql zip soap bcmath calendar xsl gd mbstring \
    && docker-php-ext-enable xsl \
    && rm -rf /var/lib/apt/lists/*


# Instalar Node.js y Yarn usando Corepack
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && corepack enable

# Verificar versiones de Node.js y Yarn
RUN node -v && yarn --version

# Instalar composer sin auto-update
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Instalar herramientas externas en una sola capa
RUN mkdir -p /usr/local/src \
    && curl -L -o /usr/local/src/phpCAS.tar.gz https://github.com/apereo/phpCAS/archive/refs/tags/1.6.0.tar.gz \
    && mkdir -p /usr/src/phpCAS \
    && tar -xzf /usr/local/src/phpCAS.tar.gz -C /usr/src/phpCAS --strip-components=1 \
    && rm /usr/local/src/phpCAS.tar.gz \
    && curl -L -o /usr/local/src/simplesamlphp.tar.gz https://github.com/simplesamlphp/simplesamlphp/releases/download/v2.0.7/simplesamlphp-2.0.7.tar.gz \
    && mkdir -p /var/www/simplesamlphp \
    && tar -xzf /usr/local/src/simplesamlphp.tar.gz -C /var/www/simplesamlphp --strip-components=1 \
    && rm /usr/local/src/simplesamlphp.tar.gz \
    && curl -L -o /usr/local/src/securimage.zip https://github.com/dapphp/securimage/archive/refs/heads/master.zip \
    && unzip /usr/local/src/securimage.zip -d /var/www/securimage \
    && rm /usr/local/src/securimage.zip

# Crear directorio de trabajo y asignar permisos
RUN mkdir -p /data \
    && chown -R www-data:www-data /data

# Cambiar UID de Apache
RUN sed -i -e 's/:33:33:/:1000:1000:/' -e 's/:33/:1000/' /etc/passwd \
    && sed -i -e 's/:33/:1000/' /etc/group

# Configuración de logs de Apache
RUN sed -i -e 's|/proc/self/fd/1|/var/log/apache2/access.log|' \
           -e 's|/proc/self/fd/2|/proc/self/fd/1|' /etc/apache2/apache2.conf

# Copiar y dar permisos al script de entrada
COPY start.sh /entrypoint-dir/start.sh
RUN chmod +x /entrypoint-dir/start.sh

# Exponer el puerto 80
EXPOSE 80

# Establecer el directorio de trabajo
WORKDIR /data

# Definir el punto de entrada
ENTRYPOINT ["/entrypoint-dir/start.sh"]