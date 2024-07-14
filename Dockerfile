FROM alpine:3.20

RUN apk add --no-cache ca-certificates openssl \
    && rm -rf /var/cache/apk/*


ENTRYPOINT ["/usr/bin/openssl"]
