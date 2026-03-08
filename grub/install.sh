#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo cp "$SCRIPT_DIR/grub" /etc/default/grub
sudo cp -r "$SCRIPT_DIR/catppuccin-mocha-grub-theme" /usr/share/grub/themes/
sudo grub-mkconfig -o /boot/grub/grub.cfg
