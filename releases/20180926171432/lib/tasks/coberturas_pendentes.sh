#!/usr/bin/env bash
source /etc/profile.d/rvm.sh
cd /var/www/webtecmaster

./bin/rails r "Emailer.coberturas_pendentes.deliver_now" 
