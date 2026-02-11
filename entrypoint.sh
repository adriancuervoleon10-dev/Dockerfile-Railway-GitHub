#!/bin/bash
set -e

# Fix MPM
a2dismod mpm_event mpm_worker || true
a2enmod mpm_prefork

# Fix ServerName (warnings)
echo "ServerName localhost" >> /etc/apache2/apache2.conf

# FIX PUERTO RAILWAY (lo clave que faltaba)
PORT=${PORT:-8080}
sed -i "s/Listen [0-9]\+/Listen $PORT/g" /etc/apache2/ports.conf
sed -i "s/<VirtualHost \*:80>/<VirtualHost \*:$PORT>/g" /etc/apache2/sites-available/000-default.conf
sed -i "s/80/$PORT/g" /etc/apache2/sites-available/000-default.conf

echo "Apache configurado para puerto $PORT"

# Test
apache2ctl -t

# Arranca
exec apache2-foreground
