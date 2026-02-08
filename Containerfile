FROM scratch AS ctx
COPY build_files /

FROM ghcr.io/ublue-os/bazzite-deck-gnome:stable-43

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/handheld/build.sh

COPY system_files/common system_files/handheld /

RUN bootc container lint
