#!/bin/sh

rm /etc/apache2/sites-enabled/000-default.conf

ln -s ${WORKDIR}/instalacion/toba.conf /etc/apache2/sites-enabled/toba.conf

a2enmod rewrite
/usr/sbin/apachectl -DFOREGROUND