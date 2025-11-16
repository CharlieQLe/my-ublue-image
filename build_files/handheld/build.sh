#!/bin/bash

set -ouex pipefail

# Disable display manager
systemctl disable sddm.service

# Cleanup packages
dnf5 -y remove kde* plasma* breeze*

# Install packages
dnf5 install -y \
  adw-gtk3-theme \
  blueman \
  gcr \
  git-lfs \
  gtk4-layer-shell \
  mate-polkit \
  nautilus \
  niri \
  ncdu \
  podman-compose \
  rclone \
  rsms-inter-fonts \
  solaar \
  xr-hardware \
  yubikey-manager-qt

# Enable services
systemctl --global enable gcr-ssh-agent.socket
systemctl enable input-remapper.service

# Install and setup DMS
dnf5 -y copr enable avengemedia/dms
dnf5 -y install dms dms-greeter
dnf5 -y copr disable avengemedia/dms
systemctl enable greetd.service
systemctl --global add-wants niri.service dms.service

# Install starship
dnf5 -y copr enable atim/starship
dnf5 -y install starship
dnf5 -y copr disable atim/starship

# Install CoolerControl
dnf5 -y copr enable codifryed/CoolerControl
dnf5 -y install coolercontrol coolercontrold
dnf5 -y copr disable codifryed/CoolerControl
systemctl enable coolercontrold.service

# Install OpenRazer
curl -Lo /etc/yum.repos.d/hardware:razer.repo https://openrazer.github.io/hardware:razer.repo
dnf5 -y install openrazer-daemon
rm -f /etc/yum.repos.d/hardware:razer.repo
systemctl --global enable openrazer-daemon.service

# Session handling
cp /ctx/handheld/files/steamos-session-select /usr/bin/steamos-session-select
rm -f /usr/share/wayland-sessions/plasma-steamos-wayland-oneshot.desktop
rm -f /etc/xdg/autostart/steam.desktop