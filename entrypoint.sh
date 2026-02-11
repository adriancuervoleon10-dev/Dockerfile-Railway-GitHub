#!/bin/bash
set -e

# Fix MPM
a2dismod mpm_event mpm_worker || true
a2enmod mpm_prefork

# Fix ServerName
echo "ServerName localhost" >> /etc/apache2/apache2.conf

# FIX PUERTO RAILWAY (MÉTODO SEGURO - sin sed destructivo)
PORT=${PORT:-8080}
echo "Configurando Apache para puerto $PORT"

# MÉTODO 1: Puerto directo en apache2.conf (más seguro)
echo "Listen $PORT" >> /etc/apache2/ports.conf

# MÉTODO 2: Recrear virtualhost limpio
cat > /etc/apache2/sites-available/000-default.conf << EOF
<VirtualHost *:$PORT>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html
    
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
    
    <Directory /var/www/html>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF

# Activar sitio
a2ensite 000-default

echo "Configuración completa para puerto $PORT"

# Test
apache2ctl -t

# Arranca
exec apache2-foreground
