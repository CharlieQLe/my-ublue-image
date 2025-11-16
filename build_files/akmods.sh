#!/usr/bin/bash

set -eoux pipefail

dnf5 -y install /rpms/akmods/rpms/ublue-os/ublue-os-akmods*.rpm

# Install OpenRazer
dnf5 -y install /rpms/akmods/rpms/kmods/kmod-openrazer*.rpm
curl -Lo /etc/yum.repos.d/hardware:razer.repo https://openrazer.github.io/hardware:razer.repo
dnf5 -y install openrazer-daemon
rm -f /etc/yum.repos.d/hardware:razer.repo
systemctl --global enable openrazer-daemon.service