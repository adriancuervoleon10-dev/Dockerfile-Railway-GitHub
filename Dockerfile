FROM php:8.2-apache

# 1. Limpieza de módulos MPM para evitar conflictos
RUN rm -f /etc/apache2/mods-enabled/mpm_event.load /etc/apache2/mods-enabled/mpm_worker.load
RUN a2dismod mpm_event || true && a2enmod mpm_prefork

# 2. Instalación de extensiones
RUN docker-php-ext-install pdo pdo_mysql

# 3. CONFIGURACIÓN DEL PUERTO (Corregida)
# Cambiamos el puerto en los archivos de configuración de Apache
RUN sed -i 's/80/${PORT}/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf

# 4. Copiamos tus archivos
COPY src/ /var/www/html/

# 5. Permisos
RUN chown -R www-data:www-data /var/www/html

# 6. INICIO (Forma recomendada para evitar errores de sintaxis)
# Usamos el puerto 80 como valor por defecto, pero Railway lo sobrescribirá
ENV PORT=80
ENTRYPOINT ["apache2-foreground"]
