#!/usr/bin/env bash
while sleep 1; do
  if pgrep -x Hyprland >/dev/null 2>&1; then
    # shellcheck disable=SC2312
    if ! hyprctl monitors 2>&1 | grep -P '^(Monitor\s.*|\s+disabled.*)$' | grep 'disabled: false' -q; then
      # Forcefully enabling dummy plug
      echo "Enabling fallback monitor!"
      hyprctl keyword monitor HDMI-A-1,enabled
    elif hyprctl monitors | grep -A0 -B0 "Monitor HDMI-A-1" -q && hyprctl monitors 2>&1 | grep -P '^(Monitor\s.*|\s+disabled: false.*)$' | grep -A0 Monitor --no-group-separator | grep -v 'HDMI-A-1' -q; then
      echo "Disabling Dummy Plug"
      hyprctl keyword monitor HDMI-A-1,disabled
    fi
    continue
  fi
  get_session_type() {
    # Get systemd session type
    # FIXME: hyprland doesn't show as "active", but as a seat on tty3
    # user_sessions=$(loginctl list_sessions | grep "$USER")
    # shellcheck disable=SC2312
    _session_type=$(loginctl 2>/dev/null show-session "$(awk '/tty/ {print $1}' <(loginctl list-sessions | grep "${USER}" | grep "active" -w))" -p Type | awk -F= '{print $2}')

    if [[ -n ${_session_type} ]]; then
      echo "${_session_type}"
    else
      environment=$(env)
      if grep -qc "WAYLAND_DISPLAY" <<<"${environment}"; then
        echo "wayland"
      elif grep -qc "DISPLAY" <<<"${environment}"; then
        echo "x11"
      fi
    fi
    echo "none"
  }
  # if [[ "$(loginctl 2>/dev/null show-session "$(awk '/tty/ {print $1}' <(loginctl list-sessions | grep "$USER" | grep "active" -w))" -p Type | awk -F= '{print $2}')" == "wayland" ]]; then
  # shellcheck disable=SC2312
  if [[ "$(get_session_type)" == "wayland" ]]; then
    export WAYLAND_DISPLAY=wayland-1
    if [[ "$(wlr-randr | grep 'Enabled: yes' -c --no-group-separator)" -lt 1 ]]; then
      if [[ ${XDG_SESSION_DESKTOP} == "Hyprland" ]]; then
        hyprctl keyword monitor HDMI-A-1,enabled
      else
        wlr-randr --output HDMI-A-1 --on
      fi
    elif wlr-randr | grep -B5 'Enabled: yes' --no-group-separator | grep -v '^\s' | grep -v HDMI-A-1 -q; then
      if [[ ${XDG_SESSION_DESKTOP} == "Hyprland" ]]; then
        hyprctl keyword monitor HDMI-A-1,disabled
      else
        wlr-randr --output HDMI-A-1 --off
      fi
    fi
  fi
done
