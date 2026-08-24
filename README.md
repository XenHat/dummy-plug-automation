# Dummy Plug helper for Linux

Automation for remote streaming using a dummy plug on Linux, supporting both Xorg/X11 and Wayland.

## What is this for?

> My setup is essentially this: I use my main computer both as a normal machine I sit in front of, and a "cloud gaming" machine where I use a headless display (Dummy plug, but can be done in software too) to avoid leaving my monitors enabled when I game remotely.
 
> When I connect my moonlight client to the PC, it runs my script and disables all monitors except the dummy plug, changes the resolution to the client's resolution to avoid scaling lag and other issues, then configures HDR/refresh rate accordingly as well.

> When I end the session, the script does what it can to undo the changes and restore the setup as it was before the stream started.

_The wording above is from a conversation and will likely be refined over time_.

## Supported Desktop Environments and Window Managers

- [x] KDE5/6
- [x] Niri

## Supported Moonlight client features

- [x] HDR mode change
- [x] Refresh rate change
- [x] Resolution change
- [ ] Optimize game performance (not implemented yet)

## Extra features

- [x] VRR mode change
- [x] Disable all displays except one on stream start and re-enable them on stream end
- [x] Revert desktop to a specified resolution on stream end

## Usage

usage: `dpa [do|undo]`

### Sunshine integration

To use this with [Sunshine][sunshine-website], add the command as a "preparation command" in your web configuration, usually available at [this url][local-webui]:
<img width="1289" height="172" alt="image" src="https://github.com/user-attachments/assets/b2a60ef4-fd58-4fb1-8ec3-c4964f954ff9" />

You can achieve the same result by editing `~/.config/sunshine/sunshine.conf`:

```conf
global_prep_cmd = [{"do":"sh -c \"/path/to/dpa do\"","undo":"sh -c \"/path/to/dpa undo\""}]
```

The display variables must be available to the Sunshine process. Putting them
in `~/.profile` only works when Sunshine is launched from a login shell; it is
not reliable for a `systemd --user` Sunshine service. For a user service, use a
small wrapper and reference the wrapper from Sunshine:

```bash
#!/usr/bin/env bash
export DEFAULT_SEAT_DISPLAY=DP-2
export DEFAULT_STREAM_DISPLAY=HDMI-A-2
export DEFAULT_KEEP_DISPLAYS="DP-2 HDMI-A-1"
export DEFAULT_RESOLUTION=2560x1440
export DEFAULT_REFRESH_RATE=165
export DEFAULT_VRR_MODE=automatic
export DEFAULT_HDR=disable
exec /path/to/dpa "$@"
```

Save it as `~/.local/bin/dpa-sunshine`, make it executable, and use it in the
Sunshine preparation command:

```conf
global_prep_cmd = [{"do":"sh -c \"$HOME/.local/bin/dpa-sunshine do\"","undo":"sh -c \"$HOME/.local/bin/dpa-sunshine undo\""}]
```

Alternatively, import variables into the user manager before starting
Sunshine, or use `~/.config/environment.d/` and log in again. The wrapper is
preferred because it keeps the display configuration next to the commands
that use it.
### Overriding the client resolution

To have a different resolution for a specific app, add the script as the application-specific do/undo command, with the added `--res-override=WIDTHxHEIGHT` parameter and untick the "Global Prep Commands":

<img width="1146" height="644" alt="Image" src="https://github.com/user-attachments/assets/2ac42b98-2089-41c3-93df-82aaf48b77cc" />


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

These variables are suitable for interactive shell use. When Sunshine runs as
a `systemd --user` service, provide them through a wrapper as described above
instead of relying only on `~/.profile`.

In case you only have one output/monitor, you can leave `DEFAULT_STREAM_DISPLAY` unset, automatic detection will occur and treat `DEFAULT_SEAT_DISPLAY` as the stream output.

[sunshine-website]: https://app.lizardbyte.dev/Sunshine/
[local-webui]: https://localhost:47990/config
