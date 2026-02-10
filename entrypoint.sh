#!/bin/bash
set -e

# Fix MPM justo antes de arrancar Apache (para Railway)
a2dismod mpm_event mpm_worker || true
a2enmod mpm_prefork

# Test config Apache
apache2ctl -t

# Arranca Apache
exec apache2-foreground
