# 1. Usar la imagen base de PHP con Apache
FROM php:8.2-apache

# 2. Dependencias del sistema y extensiones para MySQL
# Cambiamos libpq-dev (Postgres) por default-libmysqlclient-dev
RUN apt-get update && apt-get install -y \
    default-mysql-client \
    libmariadb-dev \
    && docker-php-ext-install pdo pdo_mysql mysqli \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 3. Configurar Apache en puerto 8080 (Como el ejemplo del profesor)
RUN sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf \
    && sed -i 's/:80/:8080/' /etc/apache2/sites-available/000-default.conf

# 4. Habilitar mod_rewrite para URLs amigables
RUN a2enmod rewrite

# 5. Copiar el código fuente y las bases de datos antiguas (si las vas a migrar)
COPY src/ /var/www/html/
# Si necesitas los archivos .mdb para referencia, los copiamos también
COPY BasesDeDatos/ /var/www/html/BasesDeDatos/

# 6. Permisos de carpetas
RUN chown -R www-data:www-data /var/www/html

# 7. Entrypoint para inicializar y arrancar
# He simplificado el printf para que sea más legible
RUN printf "%s\n" \
    "#!/bin/bash" \
    "set -e" \
    "echo 'Esperando a MySQL e iniciando aplicación...'" \
    "apache2-foreground" > /usr/local/bin/entrypoint.sh \
    && chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]