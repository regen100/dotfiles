#!/bin/bash

set -euo pipefail

readonly dir=$(dirname "$(realpath -s "$0")")
readonly data="$dir/data"
mkdir "$data"
trap 'rm -rf "$data"' EXIT

declare -a options=()
declare -a backup=("$dir" /boot /etc /root /usr/local)
while IFS= read -r d; do if ! pacman -Qo "/opt/$d" >/dev/null 2>&1 ; then backup+=("/opt/$d"); fi; done < <(ls -1 /opt)

# include local settings
readonly hostname=$(uname -n)
source "$dir/$hostname.conf"
if [[ ! -v repo ]]; then
  echo "repo is not defined" >&2
  exit 1
fi
if [[ -e "$dir/$hostname.exclude" ]]; then
  options+=(--exclude-from "$dir/$hostname.exclude")
fi

# backup package list
mkdir -p "$data/pacman"
pacman -Q >"$data/pacman/Q"
pacman -Qeq >"$data/pacman/Qeq"
pacman -Qii | awk '/^UNMODIFIED/ {print $2}' >"$data/pacman/unmodified"
options+=(--exclude-from "$data/pacman/unmodified")

borg --version
echo "repo: $repo"
echo "backup: ${backup[@]}"

borg create \
  --stats \
  --list \
  --filter=AME \
  --compression=zstd \
  --exclude-caches \
  --exclude "$repo" \
  --exclude-from "$dir/exclude" \
  "${options[@]}" \
  -- \
  "$repo::{hostname}-{now}" \
  "${backup[@]}"

borg prune \
  --stats \
  --list \
  --keep-daily 7 \
  --keep-weekly 4 \
  -- \
  "$repo"
