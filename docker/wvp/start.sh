#!/bin/bash

tee /opt/supervisord.conf <<-EOF
[unix_http_server]
file=/tmp/supervisor/supervisor.sock   ; (the path to the socket file)
chmod=0700                       ; sockef file mode (default 0700)

[supervisord]
nodaemon=true
# user=nobody
logfile=/tmp/supervisor/supervisord.log ; (main log file;default /supervisord.log)
pidfile=//tmp/supervisor/supervisord.pid ; (supervisord pidfile;default supervisord.pid)
childlogdir=/tmp/supervisor            ; ('AUTO' child log dir, default )
environment=WVP_HOST="${WVP_HOST}",WVP_PWD="${WVP_PWD}",WVP_DOMAIN="${WVP_DOMAIN}",WVP_ID="${WVP_ID}",REDIS_HOST="${REDIS_HOST}",REDIS_PORT="${REDIS_PORT}",REDIS_DB="${REDIS_DB}",REDIS_PWD="${REDIS_PWD}",ASSIST_JVM_CONFIG="${ASSIST_JVM_CONFIG}",WVP_JVM_CONFIG="${WVP_JVM_CONFIG}",ASSIST_CONFIG="${ASSIST_CONFIG}",WVP_CONFIG:="${WVP_CONFIG}"

[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

[supervisorctl]
serverurl=unix:///tmp/supervisor/supervisor.sock ; use a unix:// URL  for a unix socket

[program:assist]
command=java ${ASSIST_JVM_CONFIG} -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/opt/assist/heapdump/ -jar *.jar --spring.config.location=/opt/assist/config/application.yml --userSettings.record=/opt/media/www/record/  --media.record-assist-port=18081 ${ASSIST_CONFIG}
process_name=%(program_name)s
directory=/opt/assist
numprocs=1
minfds = 10000
minprocs = 10000
umask=022
priority=999
autostart=true
startsecs=10
startretries=3
exitcodes=0
stopsignal=TERM
stopwaitsecs=10
stopasgroup=false
killasgroup=false
# user=nobody
stdout_syslog=True
stdout_logfile=/tmp/assist-out.log
stdout_logfile_maxbytes=10MB
stdout_logfile_backups=5
stdout_capture_maxbytes=10MB
stdout_events_enabled=false
stderr_syslog=True
stderr_logfile=/tmp/assist-err.log
stderr_logfile_maxbytes=10MB
stderr_logfile_backups=5
stderr_capture_maxbytes=10MB
stderr_events_enabled=false

[program:MediaServer]
command=/opt/media/MediaServer -d -m 3
process_name=%(program_name)s
directory=/opt/assist
numprocs=1
minfds = 10000
minprocs = 10000
umask=022
priority=999
autostart=true
startsecs=10
startretries=3
exitcodes=0
stopsignal=TERM
stopwaitsecs=10
stopasgroup=false
killasgroup=false
# user=nobody
stdout_syslog=True
stdout_logfile=/tmp/MediaServer-out.log
stdout_logfile_maxbytes=10MB
stdout_logfile_backups=5
stdout_capture_maxbytes=10MB
stdout_events_enabled=false
stderr_syslog=True
stderr_logfile=/tmp/MediaServer-err.log
stderr_logfile_maxbytes=10MB
stderr_logfile_backups=5
stderr_capture_maxbytes=10MB
stderr_events_enabled=false

[program:wvp]
command=java ${WVP_JVM_CONFIG} -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/opt/wvp/heapdump/ -jar *.jar --spring.config.location=/opt/wvp/config/application.yml --media.record-assist-port=18081 ${WVP_CONFIG}
process_name=%(program_name)s
directory=/opt/wvp
numprocs=1
minfds = 10000
minprocs = 10000
umask=022
priority=999
autostart=true
startsecs=10
startretries=3
exitcodes=0
stopsignal=TERM
stopwaitsecs=10
stopasgroup=false
killasgroup=false
# user=nobody
stdout_syslog=True
stdout_logfile=/tmp/MediaServer-out.log
stdout_logfile_maxbytes=10MB
stdout_logfile_backups=5
stdout_capture_maxbytes=10MB
stdout_events_enabled=false
stderr_syslog=True
stderr_logfile=/tmp/MediaServer-err.log
stderr_logfile_maxbytes=10MB
stderr_logfile_backups=5
stderr_capture_maxbytes=10MB
stderr_events_enabled=false

EOF

mkdir -p /tmp/supervisor
# chown -R nobody:nogroup /opt/supervisord.conf /tmp/supervisor

exec /usr/bin/supervisord -c /opt/supervisord.conf