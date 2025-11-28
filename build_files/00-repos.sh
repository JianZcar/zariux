#!/bin/bash

echo "::group:: ===$(basename "$0")==="

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"
mkdir -p /var/roothome

dnf5 -y install dnf5-plugins
COPRS=(
    ublue-os/packages
    ublue-os/flatpak-test

    yalter/niri-git
    avengemedia/danklinux
    avengemedia/dms-git
    purian23/matugen
    guillermodotn/cliphist
)

for COPR in "${COPRS[@]}"; do
    echo "Enabling copr: $COPR"
    dnf5 -y copr enable "$COPR"
done

REPOFILES=(
    https://negativo17.org/repos/fedora-multimedia.repo
)

# Loop and add repos
for REPO in "${REPOFILES[@]}"; do
    dnf5 -y config-manager addrepo --from-repofile="$REPO"
done


dnf5 -y install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
