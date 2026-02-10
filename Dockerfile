FROM php:8.2-apache

# Desactivamos el módulo mpm_event y activamos mpm_prefork para evitar el error de "More than one MPM loaded"
RUN a2dismod mpm_event || true && a2enmod mpm_prefork

# Instalamos las extensiones necesarias para conectar con tu base de datos MySQL
RUN docker-php-ext-install pdo pdo_mysql

# Copiamos el contenido de tu carpeta src al directorio web de Apache
COPY src/ /var/www/html/

# Aseguramos que Apache tenga los permisos correctos sobre los archivos
RUN chown -R www-data:www-data /var/www/html

# Exponemos el puerto 80
EXPOSE 80
