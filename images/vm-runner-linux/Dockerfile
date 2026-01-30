FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
     qemu-system-x86 \
     qemu-utils \
     ovmf \
     iproute2 \
     ca-certificates \
     openssh-client \
  && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /usr/local/bin/vm-runner-entrypoint
RUN chmod +x /usr/local/bin/vm-runner-entrypoint

ENTRYPOINT ["/usr/local/bin/vm-runner-entrypoint"]
