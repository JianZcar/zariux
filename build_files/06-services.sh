#!/bin/bash

echo "::group:: ===$(basename "$0")==="

set -ouex pipefail

add_wants_niri() {
  sed -i "s/\[Unit\]/\[Unit\]\nWants=$1/" "/usr/lib/systemd/user/niri.service"
}

system_services=(
    bootc-fetch-apply-updates
    auditd
    firewalld
    greetd
    podman.socket
)

user_services=(
    dms.service
    cliphist.service
    dsearch.service
    gnome-keyring-daemon.socket
    gnome-keyring-daemon.service
    swayidle.service
    xwayland-satellite.service
    dms-brightness-osd.service
)

set_preset=(
    cliphist
    swayidle
    xwayland-satellite
)

mask_services=(
    systemd-remount-fs.service
    flatpak-add-fedora-repos.service
    rpm-ostree-countme.service
    rpm-ostree-countme.timer
    logrotate.service
    logrotate.timer
    akmods-keygen@akmods-keygen.service
    user@"$( id -u greeter )".service
)

systemctl enable "${system_services[@]}"
systemctl mask "${mask_services[@]}"
systemctl --global enable "$user_services"
systemctl --global preset "$set_preset"

add_wants_niri cliphist.service
add_wants_niri swayidle.service
add_wants_niri xwayland-satellite.service
cat /usr/lib/systemd/user/niri.service

echo "::endgroup::"
