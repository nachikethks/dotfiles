#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo unzip -o "$SCRIPT_DIR/arch-mac-style.zip" -d /usr/share/plymouth/themes/
sudo plymouth-set-default-theme -R arch-mac-style
