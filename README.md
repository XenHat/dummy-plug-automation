# Dummy Plug helper for Linux

Automation for remote streaming using a dummy plug on Linux, supporting both Xorg/X11 and Wayland.

## Supported Desktop Environments and Window Managers

- [X] KDE5/6
- [ ] GNOME 48+ *re-write needed*
- [ ] Hyprland *re-write needed*
- [ ] bspwm *re-write needed*
- [X] Niri
- [X] Best effort using xrandr and wlrandr for others
- [ ] COSMIC (Planned)

## Usage

usage: `dpa [do|undo]`

### Sunshine integration

To use this with [Sunshine][sunshine-website], add the command as a "preparation command" in your web configuration, usually available at https://localhost:47990/config:
<img width="1289" height="172" alt="image" src="https://github.com/user-attachments/assets/b2a60ef4-fd58-4fb1-8ec3-c4964f954ff9" />

You can achieve the same result by editing `~/.config/sunshine/sunshine.conf`:

```conf
global_prep_cmd = [{"do":"sh -c \"/path/to/dpa do\"","undo":"sh -c \"/path/to/dpa undo\""}]
```

## Notes

This utility currently assumes that your main monitor is connected through Display Port (as DP-1), and your dummy plug/stream display is connected through HDMI (as HDMI-A-1), although it can be somewhat configured via **environment variables**:


```bash
# ~/.profile
DEFAULT_SEAT_DISPLAY=DP-1 # the "Main" monitor to use for use when at the computer
DEFAULT_STREAM_DISPLAY=HDMI-A-1 # the "Stream" monitor to use for streaming, i.e. a Dummy Plug, if different than the main monitor
DEFAULT_RESOLUTION=2560x1440
DEFAULT_REFRESH_RATE=240 # The refresh rate to attempt to set when quitting the stream session
DEFAULT_VRR_MODE=automatic # VRR Mode, A.K.A Freesync/GSync
```
In case you only have one output/monitor, you can leave `DEFAULT_STREAM_DISPLAY` unset, automatic detection will occur and treat `DEFAULT_SEAT_DISPLAY` as the stream output.

---
[sunshine-website]: https://app.lizardbyte.dev/Sunshine/
