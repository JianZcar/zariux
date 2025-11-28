#!/bin/bash

echo "::group:: ===$(basename "$0")==="

set -ouex pipefail

shopt -s nullglob

PKGS_TO_INSTALL=(
    # Wifi
    NetworkManager-wifi
    atheros-firmware
    brcmfmac-firmware
    iwlegacy-firmware
    iwlwifi-dvm-firmware
    iwlwifi-mvm-firmware
    mt7xxx-firmware
    nxpwireless-firmware
    realtek-firmware
    tiwilink-firmware

    # Audio
    alsa-firmware
    alsa-sof-firmware
    alsa-tools-firmware
    intel-audio-firmware

    audit
    audispd-plugins
    cifs-utils
    firewalld
    fuse
    fuse-common
    fuse-devel
    fwupd
    gvfs-mtp
    gvfs-smb
    ifuse
    jmtpfs
    libcamera{,-{v4l2,gstreamer,tools}}
    libcamera-v4l2
    libcamera-gstreamer
    libcamera-tools
    libimobiledevice
    man-db
    plymouth
    plymouth-system-theme
    rclone
    steam-devices
    systemd-container
    tuned
    tuned-ppd
    unzip
    uxplay
    whois

    pipewire
    wireplumber

    git
    yq

    ublue-brew
    uupd
    ublue-os-udev-rules
)

PKGS_TO_UNINSTALL=(
)

dnf5 -y install "${PKGS_TO_INSTALL[@]}"
# dnf5 -y remove "${PKGS_TO_UNINSTALL[@]}"

dnf -y --repo=copr:copr.fedorainfracloud.org:ublue-os:flatpak-test swap flatpak flatpak
dnf -y --repo=copr:copr.fedorainfracloud.org:ublue-os:flatpak-test swap flatpak-libs flatpak-libs
dnf -y --repo=copr:copr.fedorainfracloud.org:ublue-os:flatpak-test swap flatpak-session-helper flatpak-session-helper

sed -i 's|^ExecStart=.*|ExecStart=/usr/bin/bootc update --quiet|' /usr/lib/systemd/system/bootc-fetch-apply-updates.service
sed -i 's|^OnUnitInactiveSec=.*|OnUnitInactiveSec=7d\nPersistent=true|' /usr/lib/systemd/system/bootc-fetch-apply-updates.timer
sed -i 's|#AutomaticUpdatePolicy.*|AutomaticUpdatePolicy=stage|' /etc/rpm-ostreed.conf
sed -i 's|#LockLayering.*|LockLayering=true|' /etc/rpm-ostreed.conf

sed -i 's|uupd|& --disable-module-distrobox|' /usr/lib/systemd/system/uupd.service

tee /usr/lib/systemd/zram-generator.conf <<'EOF'
[zram0]
zram-size = min(ram, 8192)
EOF

tee /usr/lib/systemd/system-preset/91-resolved-default.preset <<'EOF'
enable systemd-resolved.service
EOF
tee /usr/lib/tmpfiles.d/resolved-default.conf <<'EOF'
L /etc/resolv.conf - - - - ../run/systemd/resolve/stub-resolv.conf
EOF

systemctl enable bootc-fetch-apply-updates
systemctl enable auditd
systemctl enable firewalld

echo "::endgroup::"
