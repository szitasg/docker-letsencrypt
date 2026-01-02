#!/bin/bash

trap "exit" SIGHUP SIGINT SIGTERM

set -ue

if [ -z "${DOMAINS}" ] ; then
    echo "No domains set, please fill -e 'DOMAINS=example.com www.example.com'"
    exit 1
fi

if [ -z "$EMAIL" ] ; then
    echo "No email set, please fill -e 'EMAIL=your@email.tld'"
    exit 1
fi

DOMAINS=(${DOMAINS})
CHECK_FREQ="${CHECK_FREQ:-30}"

check() {
    echo "* Starting initial certificate request script..."

    for DOMAIN in ${DOMAINS}; do
        certbot certonly \
            --agree-tos \
            --non-interactive \
            --expand \
            --cert-name ${DOMAIN} \
            --email ${EMAIL} \
            --domains ${DOMAIN} \
            --standalone

        echo "* Certificate request process finished for domain ${DOMAIN}"

        if [ "${CERTS_PATH}" ] ; then
            echo "* Copying certificates to ${CERTS_PATH}"
            eval cp /etc/letsencrypt/live/${DOMAIN}/* ${CERTS_PATH}/
        fi
    done

    echo "* Next check in $CHECK_FREQ days"
    sleep ${CHECK_FREQ}d
    check
}

check
