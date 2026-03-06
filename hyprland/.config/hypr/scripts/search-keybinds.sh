#!/usr/bin/env bash

TAGS_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/hypr/keybind-tags.conf"

hyprctl binds -j | jq -r '.[] |
  (
    [
      if ((.modmask / 64 | floor) % 2) == 1 then "SUPER" else empty end,
      if ((.modmask / 8  | floor) % 2) == 1 then "ALT"   else empty end,
      if ((.modmask / 4  | floor) % 2) == 1 then "CTRL"  else empty end,
      if (.modmask % 2) == 1               then "SHIFT"  else empty end,
      .key
    ] | join("+")
  ) as $combo |
  if .has_description then
    "\($combo)  →  \(.description)"
  else
    "\($combo)  →  \(.dispatcher)\(if .arg != "" then "  \(.arg)" else "" end)"
  end
' | while IFS= read -r line; do
    desc="${line#*→  }"
    tags=""
    if [[ -f "$TAGS_FILE" ]]; then
        tags=$(grep -m1 "^${desc}=" "$TAGS_FILE" | cut -d= -f2-)
    fi
    if [[ -n "$tags" ]]; then
        printf '%s\0meta\x1f%s\n' "$line" "$tags"
    else
        printf '%s\n' "$line"
    fi
done | rofi -dmenu -i -p "  keybinds"
