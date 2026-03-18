#!/bin/sh

set -eu

mount_point="${1:?mount point required}"
share_url="${2:-//guest:@tiefenbacher/public}"

mkdir -p "$mount_point"

if /sbin/mount | /usr/bin/grep -F " on $mount_point (" >/dev/null 2>&1; then
  exit 0
fi

exec /sbin/mount_smbfs -N "$share_url" "$mount_point"
