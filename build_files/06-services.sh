#!/bin/bash

echo "::group:: ===$(basename "$0")==="

set -ouex pipefail

services=(
    podman.socket
)

user_services=(
)

mask_services=(
    systemd-remount-fs.service
    flatpak-add-fedora-repos.service
    rpm-ostree-countme.service
    rpm-ostree-countme.timer
    logrotate.service
    logrotate.timer
)
#
systemctl enable "${services[@]}"
systemctl mask "${mask_services[@]}"
# systemctl --global enable "$user_services"
#
echo "::endgroup::"
