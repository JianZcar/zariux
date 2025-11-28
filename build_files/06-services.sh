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

add_wants_niri() {
    sed -i "s/\[Unit\]/\[Unit\]\nWants=$1/" "/usr/lib/systemd/user/niri.service"
}
add_wants_niri cliphist.service
add_wants_niri swayidle.service
add_wants_niri xwayland-satellite.service
cat /usr/lib/systemd/user/niri.service

systemctl enable --global dms.service
systemctl enable --global cliphist.service
systemctl enable --global gnome-keyring-daemon.socket
systemctl enable --global gnome-keyring-daemon.service
systemctl enable --global swayidle.service
systemctl enable --global xwayland-satellite.service
systemctl preset --global cliphist
systemctl preset --global swayidle
systemctl preset --global xwayland-satellite

echo "::endgroup::"
