#!/bin/bash
set -e

# Fix MPM
a2dismod mpm_event mpm_worker || true
a2enmod mpm_prefork

# Fix ServerName
echo "ServerName localhost" >> /etc/apache2/apache2.conf

# FIX PUERTO RAILWAY (SOLO limpia duplicados)
PORT=${PORT:-8080}
echo "Configurando Apache para puerto $PORT"

# LIMPIAR duplicados Listen (SOLUCIoN)
sed -i '/Listen [0-9]\+/d' /etc/apache2/ports.conf
echo "Listen $PORT" >> /etc/apache2/ports.conf

# Recrear VirtualHost LIMPIO
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

echo " Configuracion completa para puerto $PORT"

# Test CRiTICO
if apache2ctl -t; then
    echo "Apache config OK"
else
    echo "Apache config FAILED"
    exit 1
fi

# Arranca
exec apache2-foreground
