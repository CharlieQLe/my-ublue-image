#!/bin/bash

set -ouex pipefail

# Disable display manager
systemctl disable gdm.service

# Cleanup packages
dnf5 -y remove \
    *gnome* \
    *gdm* \
    --exclude=gnome-disk-utility,gnome-autoar,gnome-desktop4,gnome-desktop3,xdg-desktop-portal-gnome,nautilus,gnome-keyring,gnome-keyring-pam

# Install packages
dnf5 install -y \
  blueman \
  gcr \
  gtk4-layer-shell \
  ncdu \
  podman-compose \
  rclone \
  rsms-inter-fonts \
  udiskie \
  xr-hardware \
  xwayland-satellite \
  yubikey-manager-qt

# Install niri from copr
dnf5 -y copr enable yalter/niri
dnf5 -y install \
    --from-repo=copr:copr.fedorainfracloud.org:yalter:niri \
    niri
dnf5 -y copr disable yalter/niri

# Install my packages
dnf5 -y copr enable charlieqle/rpmspec
dnf5 -y install \
    sysboard \
    wvkbd-deskintl \
    wvkbd-mobintl
dnf5 -y copr disable charlieqle/rpmspec

# Enable services
systemctl --global enable gcr-ssh-agent.socket
systemctl enable input-remapper.service

# Install and setup DMS
dnf5 -y copr enable avengemedia/dms-git
dnf5 -y install quickshell-git dms dms-greeter
dnf5 -y copr disable avengemedia/dms-git
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
dnf5 -y copr enable jackgreiner/lsfg-vk-git
dnf5 -y install lsfg-vk lsfg-vk-ui
dnf5 -y copr disable jackgreiner/lsfg-vk-git

# Install InputPlumber
dnf5 -y copr enable shadowblip/InputPlumber
dnf5 -y install inputplumber
dnf5 -y copr disable shadowblip/InputPlumber
systemctl enable inputplumber

# Install packages from terra repo
dnf5 -y install --from-repo=terra \
    steamos-manager \
    steamos-manager-gamescope-session-plus \
    steam_notif_daemon \
    gamescope-session-ogui-steam \
    gamescope-session-opengamepadui \
    opengamepadui \
    gamescope-session-steam

# Disable Bazzite features
systemctl disable flatpak-add-fedora-repos.service
rm -f \
  /usr/share/wayland-sessions/plasma-steamos-wayland-oneshot.desktop \
  /usr/share/wayland-sessions/gnome-wayland-oneshot.desktop \
  /usr/share/xsessions/plasma-steamos-oneshot.desktop \
  /usr/share/xsessions/gnome-steamos-oneshot.desktop \
  /usr/share/xsessions/gnome-xorg-oneshot.desktop \
  /usr/bin/startplasma-steamos-oneshot \
  /etc/xdg/autostart/steam.desktop

# Fix Steam desktop file
sed -i 's@/usr/bin/bazzite-steam@env LD_PRELOAD=/usr/lib/extest/libextest.so /usr/bin/steam@g' /usr/share/applications/steam.desktop
