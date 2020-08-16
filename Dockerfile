FROM python:3.8-alpine

ENV PYTHONUNBUFFERED=1 \
    POETRY_VERSION=1.0.5 \
    POETRY_HOME=/etc/poetry

RUN mkdir /app
WORKDIR /app

ENV PATH="${POETRY_HOME}/bin:${PATH}"
RUN wget https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py \
    && python get-poetry.py --version $POETRY_VERSION --yes \
    && rm -f get-poetry.py
COPY pyproject.toml poetry.lock /app/

RUN apk add --no-cache --virtual .build-deps \
    build-base \
    libffi-dev \
    mariadb-dev \
    && apk add --no-cache \
        mariadb-connector-c-dev \
        nginx \
        supervisor \
        tzdata \
    && TZ=${TZ:-Asia/Seoul} \
    && cp /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone \
    && pip install --upgrade pip \
    && poetry config virtualenvs.create false \
    && poetry install --no-dev \
&& apk del .build-deps \
&& rm -rf /var/cache/apk/*

RUN mkdir -p /app \
&& ln -sf /dev/stdout /var/log/nginx/access.log \
&& ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80
COPY docker/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
ENTRYPOINT ["docker-entrypoint"]
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf", "-n"]

COPY docker/supervisor /etc/supervisor
COPY docker/nginx /etc/nginx

COPY src /app/src
