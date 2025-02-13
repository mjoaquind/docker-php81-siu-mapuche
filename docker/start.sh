#!/bin/sh

rm /etc/apache2/sites-enabled/000-default.conf

ln -s /data/scripts/mapuche.conf /etc/apache2/sites-enabled/mapuche.conf

a2enmod rewrite
/usr/sbin/apachectl -DFOREGROUND