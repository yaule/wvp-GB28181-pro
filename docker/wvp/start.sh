#!/bin/bash

cat /etc/supervisor/supervisord.conf >/opt/supervisord.conf

chown -R nobody:nogroup /opt/supervisord.conf

exec /usr/bin/supervisord -c /opt/supervisord.conf