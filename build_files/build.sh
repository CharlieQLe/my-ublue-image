#!/bin/bash

set -ouex pipefail

# Install packages
dnf5 install -y \
  gtk4-layer-shell \
  blueman \
  mate-polkit \
  niri \
  ddcutil \
  git-lfs \
  ncdu \
  rclone \
  solaar \
  yubikey-manager-qt \
  adw-gtk3-theme \
  btop \
  fprintd-pam \
  qt5-qtwayland \
  qt6-qtwayland \
  rocm-smi \
  Sunshine \
  xr-hardware \
  dbus-x11 \
  podman-compose

# Install and setup DMS
dnf5 -y copr enable avengemedia/dms
dnf5 -y install dms dms-greeter
dnf5 -y copr disable avengemedia/dms
systemctl enable greetd.service
systemctl --user enable dms.service

# Install starship
dnf5 -y copr enable atim/starship
dnf5 -y install starship
dnf5 -y copr disable atim/starship

# Install ladspa
dnf5 -y copr enable ycollet/audinux
dnf5 -y install ladspa-caps-plugins ladspa-noise-suppression-for-voice
dnf5 -y copr disable ycollet/audinux

# Remove Firefox
dnf5 remove -y firefox firefox-langpacks