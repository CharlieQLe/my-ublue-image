#!/usr/bin/bash

set -eoux pipefail

dnf5 -y install /rpms/akmods/rpms/ublue-os/ublue-os-akmods*.rpm
dnf5 -y install /rpms/akmods/rpms/kmods/kmod-openrazer*.rpm
