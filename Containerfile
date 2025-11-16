FROM ghcr.io/ublue-os/akmods:main-43 AS akmods

FROM scratch AS ctx
COPY build_files /

FROM ghcr.io/ublue-os/base-main:43

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/cachyos_kernel.sh

#RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
#    --mount=type=bind,from=akmods,source=/,dst=/rpms/akmods \
#    --mount=type=cache,dst=/var/cache \
#    --mount=type=cache,dst=/var/log \
#    --mount=type=tmpfs,dst=/tmp \
#    /ctx/akmods.sh

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh
    
RUN bootc container lint
