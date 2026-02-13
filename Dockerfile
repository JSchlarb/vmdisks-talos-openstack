FROM alpine:latest

# renovate: datasource=github-releases depName=talos packageName=siderolabs/talos
ARG TALOS_VERSION=v1.12.4
ARG TALOS_ARCH=amd64

RUN apk add xz curl

RUN mkdir /disk \
  && curl -L "https://factory.talos.dev/image/ce4c980550dd2ab1b17bbf2b08801c7eb59418eafe8f279833297925d67c7515/${TALOS_VERSION}/openstack-${TALOS_ARCH}.raw.xz" | \
     xz -dc > /disk/talos-${TALOS_VERSION}-${TALOS_ARCH}.img

FROM scratch

COPY --from=0 --chown=107:107 /disk /disk
