# Dummy Plug helper for Linux

Automation for remote streaming using a dummy plug on Linux, supporting both Xorg/X11 and Wayland.


## Supported Desktop Environments and Window Managers

- [X] KDE5/6
- [ ] GNOME 48+ *re-write needed*
- [ ] Hyprland *re-write needed*
- [X] bspwm *re-write needed*
- [X] Niri
- [X] Best effort using xrandr and wlrandr for others
- [ ] COSMIC (Planned)


## Usage:w


usage: `dpa [do|undo]`

Example usage using a global prep command in Sunshine:

```conf
global_prep_cmd = [{"do":"sh -c \"~/code/xenhat/dummy-plug-automation/dpa do\"","undo":"sh -c \"~/code/xenhat/dummy-plug-automation/dpa undo\""}]
```

## Notes

This utility currently assumes that your main monitor is connected through Display Port (as DP-1), and your dummy plug/stream display is connected through HDMI (as HDMI-A-1).

There are some experimental environment variables to configure this script at the moment:
```bash
# ~/.profile
DEFAULT_SEAT_DISPLAY=DP-1 # the "Main" monitor to use for use when at the computer
DEFAULT_STREAM_DISPLAY=HDMI-A-1 # the "Stream" monitor to use for streaming, i.e. a Dummy Plug
DEFAULT_RESOLUTION=2560x1440
DEFAULT_REFRESH_RATE=240 # The refresh rate to attempt to set when quitting the stream session
DEFAULT_VRR_MODE=automatic # VRR Mode, A.K.A Freesync/GSync
```
```
