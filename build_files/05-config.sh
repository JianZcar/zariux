#!/bin/bash

echo "::group:: ===$(basename "$0")==="

set -ouex pipefail

/ctx/helper/config-apply.sh

sed -i 's/balanced=balanced$/balanced=balanced-bazzite/' /etc/tuned/ppd.conf
sed -i 's/performance=throughput-performance$/performance=throughput-performance-bazzite/' /etc/tuned/ppd.conf
sed -i 's/balanced=balanced-battery$/balanced=balanced-battery-bazzite/' /etc/tuned/ppd.conf

echo "::endgroup::"
