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
  xr-hardware \
  dbus-x11 \
  podman-compose \
  nautilus \
  ptyxis \
  gcr

# Install Sunshine
dnf5 -y copr enable lizardbyte/beta
dnf5 -y install Sunshine
dnf5 -y copr disable lizardbyte/beta

# Install and setup DMS
dnf5 -y copr enable avengemedia/dms
dnf5 -y install dms dms-greeter
dnf5 -y copr disable avengemedia/dms
systemctl enable greetd.service
systemctl --global enable dms.service

# Install starship
dnf5 -y copr enable atim/starship
dnf5 -y install starship
dnf5 -y copr disable atim/starship

# Install ladspa
dnf5 -y copr enable ycollet/audinux
dnf5 -y install ladspa-caps-plugins ladspa-noise-suppression-for-voice
dnf5 -y copr disable ycollet/audinux

# Install CoolerControl
dnf5 -y copr enable codifryed/CoolerControl
dnf5 -y install coolercontrol lm_sensors
dnf5 -y copr disable codifryed/CoolerControl
systemctl enable coolercontrold.service

# Install HHD
dnf5 -y copr enable hhd-dev/hhd
dnf5 -y install \
  hhd \
  hhd-ui
dnf5 -y copr disable hhd-dev/hhd
systemctl enable hhd.service

# Install OpenRazer
curl -Lo /etc/yum.repos.d/hardware:razer.repo https://openrazer.github.io/hardware:razer.repo
dnf5 -y install openrazer-daemon
rm -f /etc/yum.repos.d/hardware:razer.repo

# Remove packages
dnf5 remove -y firefox firefox-langpacks