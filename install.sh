#!/usr/bin/env bash
set -euo pipefail

###############################################################################
#  Sync local nvim/ tree -> ~/.config/nvim/, preserving structure and         #
#  replacing/creating symlinks for every file.                                #
###############################################################################

# Directory that contains this script (your local nvim/ root)
src_root="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/nvim"
dst_root="$HOME/.config/nvim"

# This script
installer="$(basename "$0")"

echo "Installing Neovim config:"
echo "  Source : $src_root"
echo "  Target : $dst_root"
echo

# Make sure the destination root exists
mkdir -p "$dst_root"

# Extensions to skip (NO leading dot). Example: "DS_Store", "swp", "tmp"
IGNORE_EXT=( "DS_Store" )

###############################################################################
# Helper: return 0 (true) if the file should be ignored                       #
###############################################################################
should_ignore () {
    local path="$1"
    local base="${path##*/}"
    local ext="${base##*.}"

    # No dot in the name  -> ext == whole filename, that’s fine
    for ign in "${IGNORE_EXT[@]}"; do
        [[ "$ext" == "$ign" ]] && return 0
    done
    return 1
}

###############################################################################
# 1. Re-create the directory tree                                             #
###############################################################################
find "$src_root" -mindepth 1 -type d -print0 |
while IFS= read -r -d '' dir; do
    rel="${dir#$src_root/}"            # path relative to src_root
    mkdir -p "$dst_root/$rel"
done

###############################################################################
# 2. Symlink every file (skip this installer)                                 #
###############################################################################
find "$src_root" -type f -print0 |
while IFS= read -r -d '' file; do
    # Skip this installer and any ignored extension
    [[ "$(basename "$file")" == "$installer" ]] && continue
    should_ignore "$file" && continue

    rel="${file#$src_root/}"
    echo "Installing $dst_root/$rel"
    ln -sf "$file" "$dst_root/$rel"
done

echo
echo "Done."

