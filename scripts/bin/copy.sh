#!/usr/bin/env bash
set -euo pipefail

if hash pbcopy 2>/dev/null; then
    cmd='pbcopy'
elif hash xclip 2>/dev/null; then
    cmd='xclip -selection clipboard'
else
    echo 'cannot find a copy program' >&2
    exit 1
fi

perl -pe 'chomp if eof' | $cmd
