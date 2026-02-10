FROM php:8.2-apache

# 1. Extensiones MySQL
RUN docker-php-ext-install pdo pdo_mysql

# 2. Puerto FIJO para Railway (8080)
ENV APACHE_PORT=8080
RUN sed -i "s/Listen 80/Listen ${APACHE_PORT}/g" /etc/apache2/ports.conf && \
    sed -i "s/80/${APACHE_PORT}/g" /etc/apache2/sites-available/000-default.conf && \
    sed -i "s/Listen 80/Listen ${APACHE_PORT}/g" /etc/apache2/apache2.conf

# 3. MPM Limpieza (build time)
RUN a2dismod mpm_event mpm_worker || true && \
    a2enmod mpm_prefork

# 4. Copia archivos
COPY src/ /var/www/html/
RUN chown -R www-data:www-data /var/www/html

# 5. ENTRYPPOINT NUEVO (fix definitivo MPM en runtime)
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
