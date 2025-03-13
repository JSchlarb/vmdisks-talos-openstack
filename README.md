# Talos Image Openstack

## Overview

This repository provides a configuration for building a containerized Talos image cache, enabling faster provisioning of
Talos-based clusters in a homelab environment. By leveraging the image caching feature introduced in Talos 1.8, this
setup reduces dependency on external registries.

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
                    url: docker://ghcr.io/jschlarb/vmdisks/talos-openstack:v1.9.4-amd64
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
Docker images) incorporate official Talos system images and are subject to
the [Talos License](https://github.com/siderolabs/talos/blob/main/LICENSE).

## Further Reading

- For more details on Talos, visit [Sidero Labs Talos](https://www.talos.dev/).
- For information on container disk compatibility,
  see [KubeVirt Container Disks](https://kubevirt.io/user-guide/storage/disks_and_volumes/#containerdisk-workflow-example).

