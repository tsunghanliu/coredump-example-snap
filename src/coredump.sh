#!/bin/sh -ex

if [ "$(id -u)" -ne 0 ]; then
	echo "run this command as root!"
	exit 1
fi

# backup current core_pattern
CORE_PATTERN_BACKUP="$(cat /proc/sys/kernel/core_pattern)"

ulimit -c unlimited
echo 1 > /proc/sys/fs/suid_dumpable
mkdir -p ${SNAP_COMMON}/coredump
echo "${SNAP_COMMON}/coredump/core-%e-%s-%u-%g-%p-%t" > /proc/sys/kernel/core_pattern

set +e
${SNAP}/bin/coredump.real
set -e

# restore core_pattern
echo "$CORE_PATTERN_BACKUP" > /proc/sys/kernel/core_pattern
