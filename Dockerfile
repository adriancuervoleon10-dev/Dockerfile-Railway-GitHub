FROM php:8.2-apache

# 1. Instalación de extensiones para MySQL
RUN docker-php-ext-install pdo pdo_mysql

# 2. LIMPIEZA TOTAL DE MPM: 
# Borramos físicamente todos los archivos de carga de MPM y dejamos SOLO prefork
RUN find /etc/apache2/mods-enabled/ -name "mpm_*" -delete && \
    ln -s /etc/apache2/mods-available/mpm_prefork.load /etc/apache2/mods-enabled/mpm_prefork.load && \
    ln -s /etc/apache2/mods-available/mpm_prefork.conf /etc/apache2/mods-enabled/mpm_prefork.conf

# 3. CONFIGURACIÓN DEL PUERTO PARA RAILWAY
# Reemplazamos el puerto 80 por el dinámico
RUN sed -i 's/80/${PORT}/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf

# 4. Copiamos tus archivos de la carpeta src
COPY src/ /var/www/html/

# 5. Permisos
RUN chown -R www-data:www-data /var/www/html

# 6. ARRANQUE LIMPIO
# Usamos el comando directo para que no se mezcle con otras variables
CMD ["apache2-foreground"]
