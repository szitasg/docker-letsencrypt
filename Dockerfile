# https://github.com/certbot/certbot/releases
# https://hub.docker.com/r/certbot/certbot/tags
FROM certbot/certbot:v5.2.2

RUN apk update \
 && apk add --no-cache bash \
 && mkdir -p /var/lib/szitas

ADD entrypoint.sh /var/lib/szitas/entrypoint.sh

ENTRYPOINT [ "/var/lib/szitas/entrypoint.sh" ]
