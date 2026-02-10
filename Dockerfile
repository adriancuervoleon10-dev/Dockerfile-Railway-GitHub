FROM php:8.2-apache

# 1. Eliminamos cualquier rastro de otros módulos MPM para evitar conflictos
RUN rm -f /etc/apache2/mods-enabled/mpm_event.load /etc/apache2/mods-enabled/mpm_worker.load

# 2. Desactivamos mpm_event y activamos mpm_prefork
RUN a2dismod mpm_event || true && a2enmod mpm_prefork

# 3. Instalamos las extensiones para MySQL
RUN docker-php-ext-install pdo pdo_mysql

# 4. MODIFICACIÓN CLAVE PARA RAILWAY:
# Cambiamos el puerto 80 por la variable de entorno ${PORT} en toda la configuración de Apache
RUN sed -i 's/80/${PORT}/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf

# 5. Copiamos el contenido de tu carpeta src
COPY src/ /var/www/html/

# 6. Permisos correctos
RUN chown -R www-data:www-data /var/www/html

# 7. IMPORTANTE: En Railway no fijamos el puerto en 80. 
# Dejamos que use la variable dinámica.
EXPOSE ${PORT}

# 8. Iniciamos Apache
CMD ["apache2-foreground"]80
