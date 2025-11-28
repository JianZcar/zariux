#!/bin/bash

echo "::group:: ===$(basename "$0")==="

set -ouex pipefail

shopt -s nullglob

PKGS_TO_INSTALL=(
    quickshell-git
    dms
    dms-cli
    dms-greeter
    dgop

    brightnessctl
    ddcutil
    glycin-thumbnailer
    gnome-keyring
    gnome-keyring-pam
    greetd
    greetd-selinux
    orca
    udiskie
    webp-pixbuf-loader
    wl-clipboard
    wlsunset
    xdg-desktop-portal-gnome
    xdg-user-dirs
    xwayland-satellite

    ghostty


    ffmpeg
    libavcodec
    @multimedia
    gstreamer1-plugins-{bad-free,bad-free-libs,good,base}
    lame{,-libs}
    libjxl
    ffmpegthumbnailer

    cliphist
    matugen

    default-fonts-core-emoji
    google-noto-color-emoji-fonts
    google-noto-emoji-fonts
    glibc-all-langpacks
    default-fonts
)

PKGS_TO_UNINSTALL=(

)

dnf install -y --setopt=install_weak_deps=False \
    niri \
    kf6-kirigami \
    qt6ct \
    polkit-kde \
    plasma-breeze \
    kf6-qqc2-desktop-style

dnf5 -y install "${PKGS_TO_INSTALL[@]}"
# dnf5 -y remove "${PKGS_TO_UNINSTALL[@]}"

sed -i '/gnome_keyring.so/ s/-auth/auth/ ; /gnome_keyring.so/ s/-session/session/' /etc/pam.d/greetd
cat /etc/pam.d/greetd

git clone "https://github.com/zirconium-dev/zdots.git" /usr/share/zirconium/zdots
install -d /etc/niri/
cp -f /usr/share/zirconium/zdots/dot_config/niri/config.kdl /etc/niri/config.kdl
file /etc/niri/config.kdl | grep -F -e "empty" -v
stat /etc/niri/config.kdl

mkdir -p "/usr/share/fonts/Maple Mono"

MAPLE_TMPDIR="$(mktemp -d)"
trap 'rm -rf "${MAPLE_TMPDIR}"' EXIT

LATEST_RELEASE_FONT="$(curl "https://api.github.com/repos/subframe7536/maple-font/releases/latest" | jq '.assets[] | select(.name == "MapleMono-Variable.zip") | .browser_download_url' -rc)"
curl -fSsLo "${MAPLE_TMPDIR}/maple.zip" "${LATEST_RELEASE_FONT}"
unzip "${MAPLE_TMPDIR}/maple.zip" -d "/usr/share/fonts/Maple Mono"

echo "::endgroup::"
