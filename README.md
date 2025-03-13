# VM Disk Talos OpenStack

## Overview

This repository provides a containerized Talos OpenStack image intended for use in a registry with Talos’ new image
cache feature (available since Talos v1.9.0). It enables faster provisioning of KubeVirt Talos-based clusters in a
homelab environment by reducing dependency on external registries. This image is particularly effective when used in
combination with Cluster API (CAPI), KubeVirt, and KubeVirt’s Containerized Data Importer (CDI), as using the
`pullMethod: node` option minimizes pull traffic by fetching the image from the node's local cache.

## Talos Base Image Details

This setup uses a Talos base image configured with the following options:

[Talos Factory Configuration](https://factory.talos.dev/?arch=amd64&cmdline-set=true&extensions=-&extensions=siderolabs%2Fqemu-guest-agent&platform=openstack&target=cloud)

```yaml
customization:
  systemExtensions:
    officialExtensions:
      - siderolabs/qemu-guest-agent
```

## Usage

```yaml
apiVersion: infrastructure.cluster.x-k8s.io/v1alpha1
kind: KubevirtMachineTemplate
# [...]
spec:
  template:
    spec:
      virtualMachineBootstrapCheck:
        checkStrategy: none
      virtualMachineTemplate:
        # [...]
        spec:
          dataVolumeTemplates:
            - metadata:
                name: boot-volume
                namespace: default
              spec:
                pvc:
                  accessModes:
                    - ReadWriteOnce
                  storageClassName: ""
                source:
                  registry:
                    pullMethod: node # that the cool thing btw
                    url: docker://ghcr.io/jschlarb/vmdisks/talos-openstack:v1.9.5-amd64
                    #  or arm builds
                    # url: docker://ghcr.io/jschlarb/vmdisks/talos-openstack:v1.9.4-arm64 
# [...]
```

## Building

To build and push the image for different architectures:

```sh
TALOS_ARCH=amd64
TALOS_VERSION=$(cat ./talos-version.txt)
docker buildx build --push --platform linux/${TALOS_ARCH} \
    --build-arg TALOS_VERSION=${TALOS_VERSION} \
    --build-arg TALOS_ARCH=${TALOS_ARCH} \
    --tag talos-openstack:${TALOS_VERSION}-${TALOS_ARCH} .
```

## License

This repository contains only configuration files and does **not** include a license. However, the generated artifacts (
container images) incorporate official Talos system images and are subject to
the [Talos License](https://github.com/siderolabs/talos/blob/main/LICENSE).

## Further Reading

- For more details on Talos, visit [Sidero Labs Talos](https://www.talos.dev/).
- For information on container disk compatibility,
  see [KubeVirt Container Disks](https://kubevirt.io/user-guide/storage/disks_and_volumes/#containerdisk-workflow-example).

