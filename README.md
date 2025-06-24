# Dummy Plug helper for Linux

Automation for remote streaming using a dummy plug on Linux, supporting both Xorg/X11 and Wayland.

## Supported Desktop Environments and Window Managers

- [X] KDE5/6
- [X] GNOME 48+
- [X] Hyprland
- [X] bspwm
- [X] Niri
- [X] Best effort using xrandr and wlrandr for others
- [ ] COSMIC (Planned)

## Usage

usage: `dpa [do|undo]`

Example usage:

```sunshine.conf
global_prep_cmd = [{"do":"sh -c \"~/code/xenhat/dummy-plug-automation/dpa do\"","undo":"sh -c \"~/code/xenhat/dummy-plug-automation/dpa undo\""}]
```
