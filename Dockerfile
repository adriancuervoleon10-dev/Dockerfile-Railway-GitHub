FROM php:8.2-apache

# Instalamos la extensión necesaria para conectar PHP con MySQL
RUN docker-php-ext-install pdo pdo_mysql

# Copiamos solo los archivos que la gente va a ver (tu index.php)
COPY src/ /var/www/html/

# Puerto estándar
EXPOSE 80
