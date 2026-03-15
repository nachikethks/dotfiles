#!/usr/bin/env bash

set -euo pipefail

TAGS_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/hypr/keybind-tags.conf"
PID_FILE="${XDG_RUNTIME_DIR:-/run/user/$UID}/rofi-keybinds.pid"

if [[ -f "$PID_FILE" ]]; then
    pid=$(<"$PID_FILE")
    if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
        kill "$pid"
        rm -f "$PID_FILE"
        exit 0
    fi
    rm -f "$PID_FILE"
fi

declare -A tags_by_desc=()

if [[ -f "$TAGS_FILE" ]]; then
    while IFS='=' read -r desc tags; do
        [[ -z "$desc" || "$desc" == \#* ]] && continue
        tags_by_desc["$desc"]="$tags"
    done <"$TAGS_FILE"
fi

mapfile -t binds < <(
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
        [$combo, .description]
      else
        [$combo, (.dispatcher + (if .arg != "" then "  " + .arg else "" end))]
      end | @tsv'
)

combo_width=0
for bind in "${binds[@]}"; do
    IFS=$'\t' read -r combo _ <<<"$bind"
    (( ${#combo} > combo_width )) && combo_width=${#combo}
done

for bind in "${binds[@]}"; do
    IFS=$'\t' read -r combo desc <<<"$bind"
    tags="${tags_by_desc[$desc]:-}"

    if [[ -n "$tags" ]]; then
        printf '%-*s  |  %s\0meta\x1f%s\n' "$combo_width" "$combo" "$desc" "$tags"
    else
        printf '%-*s  |  %s\n' "$combo_width" "$combo" "$desc"
    fi
done | rofi -dmenu -i -p "keybinds" -theme ~/.config/rofi/themes/catppuccin-mocha.rasi -window-title "keybinds" -pid "$PID_FILE" || true

rm -f "$PID_FILE"
