FROM ghcr.io/bazzite-org/kernel-bazzite:latest-f43-x86_64 AS kernel

FROM scratch AS ctx
COPY build_files /

FROM ghcr.io/ublue-os/base-main:43

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=bind,from=kernel,source=/,dst=/rpms/kernel \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/kernel.sh

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh
    
RUN bootc container lint
