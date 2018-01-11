#!/bin/bash
set -e

trap cleanup EXIT

TMPMNT=$(mktemp -d /tmp/tmpdebugfs.XXXXXX)
DEBUGFS=$(basename ${TMPMNT})

function cleanup {
  if [ -d "${TMPMNT}" ]; then
    umount "${DEBUGFS}"
  fi
}

mount -t debugfs "${DEBUGFS}" "${TMPMNT}"
if [ -e "${TMPMNT}/x86/pti_enabled" ]; then
  if [[ $(<${TMPMNT}/x86/pti_enabled) == 1 ]]; then
    echo "This system is protected from the meltdown security issue" >&2
    exit 0
  fi
fi

echo "This system is NOT protected from the meltdown security issue" >&2
exit 1
