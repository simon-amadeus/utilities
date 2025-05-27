#!/bin/zsh

# This script attempts to fix /etc/zshrc after a macOS update
# that may have broken Nix CLI commands, keeping only one backup.

ZSHRC_PATH="/etc/zshrc"
# This will always be the same backup file, overwriting on each run
BACKUP_PATH="${ZSHRC_PATH}.bak"

# The full Nix profile block with existence check
NIX_PROFILE_BLOCK="# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
# End Nix"

# A line to check for the presence of the block
NIX_PROFILE_CHECK_LINE="if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then"

# The NIX_PATH export line (kept separate as it's a common addition)
NIX_PATH_EXPORT_LINE='export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/default/manifest.nix:/nix/var/nix/profiles/per-user/$USER/channels'

echo "Starting /etc/zshrc fix script for Nix CLI commands..."

# 1. Create a backup of the current /etc/zshrc
echo "1. Creating a backup of ${ZSHRC_PATH} to ${BACKUP_PATH}"
# The -f flag ensures cp overwrites if the file already exists
sudo cp -f "${ZSHRC_PATH}" "${BACKUP_PATH}"

if [ $? -eq 0 ]; then
    echo "   Backup created successfully (overwriting previous backup if it existed)."
else
    echo "   Error: Failed to create backup. Exiting."
    exit 1
fi

# 2. Check if the Nix profile block is already present
echo "2. Checking for Nix profile block in ${ZSHRC_PATH}..."
if grep -qF "${NIX_PROFILE_CHECK_LINE}" "${ZSHRC_PATH}"; then
    echo "   Nix profile block (with existence check) already present."
else
    echo "   Nix profile block NOT found. Appending it to ${ZSHRC_PATH}..."
    echo "" | sudo tee -a "${ZSHRC_PATH}" > /dev/null # Add a newline for separation
    echo "${NIX_PROFILE_BLOCK}" | sudo tee -a "${ZSHRC_PATH}" > /dev/null
    echo "   Nix profile block added."
fi

# 3. Check if the NIX_PATH export line is already present
echo "3. Checking for NIX_PATH export in ${ZSHRC_PATH}..."
if grep -qF "${NIX_PATH_EXPORT_LINE}" "${ZSHRC_PATH}"; then
    echo "   NIX_PATH export line already present: '${NIX_PATH_EXPORT_LINE}'"
else
    echo "   NIX_PATH export line NOT found. Appending it to ${ZSHRC_PATH}..."
    echo "${NIX_PATH_EXPORT_LINE}" | sudo tee -a "${ZSHRC_PATH}" > /dev/null
    echo "   NIX_PATH export line added."
fi

echo "Script finished."
echo "Please restart your terminal or run 'source /etc/zshrc' to apply the changes."
echo "If issues persist, you may need to manually inspect ${ZSHRC_PATH} or reinstall Nix."

