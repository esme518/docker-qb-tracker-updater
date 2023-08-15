#
# Dockerfile for qb-tracker-updater
#

FROM alpine as source

COPY --from=80x86/qb-tracker-update-bulk:v1.0.2-arm64 /usr/bin/qb-tracker-update-bulk /root/arm64/qb-tracker-updater
COPY --from=80x86/qb-tracker-update-bulk:v1.0.2-amd64 /usr/bin/qb-tracker-update-bulk /root/amd64/qb-tracker-updater

WORKDIR /root

RUN set -ex \
    && mkdir target \
    && apk add --update --no-cache tree \
    && tree \
    && if [ "$(uname -m)" == aarch64 ]; then \
           mv arm64/qb-tracker-updater target; \
       elif [ "$(uname -m)" == x86_64 ]; then \
           mv amd64/qb-tracker-updater target; \
       fi \
    && tree

FROM alpine
COPY --from=source /root/target /usr/local/bin

COPY docker-entrypoint.sh /entrypoint.sh

EXPOSE 8888

ENTRYPOINT ["/entrypoint.sh"]
CMD ["qb-tracker-updater","-nbo"]
