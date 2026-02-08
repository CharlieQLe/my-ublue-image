#!/bin/bash

set -ouex pipefail

# Disable display manager
systemctl disable sddm.service

# Cleanup packages
dnf5 -y remove \
    *gnome* \
    *gdm* \
    --exclude=gnome-disk-utility,gnome-autoar,gnome-desktop4,gnome-desktop3,xdg-desktop-portal-gnome,nautilus,gnome-keyring,gnome-keyring-pam

# Install xwayland-satellite from copr
dnf5 -y copr enable ulysg/xwayland-satellite
dnf5 -y install \
    --from-repo=copr:copr.fedorainfracloud.org:ulysg:xwayland-satellite \
    xwayland-satellite
dnf5 -y copr disable ulysg/xwayland-satellite

# Install packages
dnf5 install -y \
  blueman \
  gtk4-layer-shell \
  mate-polkit \
  ncdu \
  podman-compose \
  rclone \
  rsms-inter-fonts \
  udiskie \
  xr-hardware \
  yubikey-manager-qt

# Install niri from copr
dnf5 -y copr enable yalter/niri
dnf5 -y install \
    --from-repo=copr:copr.fedorainfracloud.org:yalter:niri \
    niri
dnf5 -y copr disable yalter/niri

# Install squeekboard
dnf5 install -y https://kojipkgs.fedoraproject.org//packages/squeekboard/1.43.1/9.fc43/x86_64/squeekboard-1.43.1-9.fc43.x86_64.rpm

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

# Install LSFG-VK
dnf5 -y install https://github.com/PancakeTAS/lsfg-vk/releases/download/v1.0.0/lsfg-vk-1.0.0.x86_64.rpm

# Remove HHD
dnf5 -y remove hhd hhd-ui

# Install InputPlumber
dnf5 -y copr enable shadowblip/InputPlumber
dnf5 -y install inputplumber
dnf5 -y copr disable shadowblip/InputPlumber
systemctl enable inputplumber

# Install packages from terra repo
dnf5 -y remove steamos-manager
dnf5 -y install --from-repo=terra \
    steamos-manager \
    steamos-manager-gamescope-session-plus

# Disable Bazzite features
systemctl disable flatpak-add-fedora-repos.service
systemctl disable bazzite-autologin.service
rm -f \
  /usr/share/wayland-sessions/plasma-steamos-wayland-oneshot.desktop \
  /usr/share/xsessions/plasma-steamos-oneshot.desktop \
  /usr/bin/startplasma-steamos-oneshot \
  /etc/xdg/autostart/steam.desktop

# Fix Steam desktop file
sed -i 's@/usr/bin/bazzite-steam@env LD_PRELOAD=/usr/lib/extest/libextest.so /usr/bin/steam@g' /usr/share/applications/steam.desktop
