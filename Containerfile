FROM scratch AS ctx
COPY build_files /

FROM ghcr.io/ublue-os/bazzite-deck:stable-43

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/handheld/build.sh
    
RUN bootc container lint