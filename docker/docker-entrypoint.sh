#!/usr/bin/env sh
set -e

export ENVIRONMENT=${ENVIRONMENT:-development}

export GUNICORN_DEBUG_LEVEL=${GUNICORN_DEBUG_LEVEL:-info}
export GUNICORN_SOCKET=${GUNICORN_SOCKET:-/var/run/gunicorn.sock}

export NGINX_DEBUG_LEVEL=${NGINX_DEBUG_LEVEL:-info}
export NGINX_SERVER_ROOT=${NGINX_SERVER_ROOT:-/app}
export NGINX_SERVER_STATIC=${NGINX_SERVER_STATIC:-/static}
export NGINX_SERVER_LISTEN_PORT=${NGINX_SERVER_LISTEN_PORT:-80}
export NGINX_HEALTH_CHECK_PATH=${NGINX_HEALTH_CHECK_PATH:-/health}


# Configure Nginx
NGINX_CONFIG=/etc/nginx/nginx.conf
cp ${NGINX_CONFIG}.tmpl ${NGINX_CONFIG}
sed -i "s|\$NGINX_DEBUG_LEVEL|${NGINX_DEBUG_LEVEL}|g" ${NGINX_CONFIG}

NGINX_SERVER_CONFIG=/etc/nginx/conf.d/default.conf
cp ${NGINX_SERVER_CONFIG}.tmpl ${NGINX_SERVER_CONFIG}
sed -i "s|\$GUNICORN_SOCKET|${GUNICORN_SOCKET}|g" ${NGINX_SERVER_CONFIG}
sed -i "s|\$NGINX_SERVER_ROOT|${NGINX_SERVER_ROOT}|g" ${NGINX_SERVER_CONFIG}
sed -i "s|\$NGINX_SERVER_STATIC|${NGINX_SERVER_STATIC}|g" ${NGINX_SERVER_CONFIG}
sed -i "s|\$NGINX_SERVER_LISTEN_PORT|${NGINX_SERVER_LISTEN_PORT}|g" ${NGINX_SERVER_CONFIG}
sed -i "s|\$NGINX_HEALTH_CHECK_PATH|${NGINX_HEALTH_CHECK_PATH}|g" ${NGINX_SERVER_CONFIG}


python /app/src/manage.py collectstatic --noinput

echo "Run command \"$@\""
exec "$@"
