FROM alpine:3.21.3

ARG TALOS_VERSION=v1.9.4
ARG TALOS_ARCH=amd64

RUN apk add xz curl

RUN curl "https://factory.talos.dev/image/ce4c980550dd2ab1b17bbf2b08801c7eb59418eafe8f279833297925d67c7515/${TALOS_VERSION}/openstack-${TALOS_ARCH}.raw.xz" | \
    xz > /tmp/image.raw

FROM scratch

LABEL TALOS_VERSION=$TALOS_VERSION \
      TALOS_ARCH=$TALOS_ARCH

COPY --from=0 --chown=107:107 /tmp/image.raw /disk/
