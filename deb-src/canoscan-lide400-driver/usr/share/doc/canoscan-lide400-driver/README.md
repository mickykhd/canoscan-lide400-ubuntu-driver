# canoscan-lide400-driver

Driver enablement package for the **Canon CanoScan LiDE 400** USB flatbed
scanner on Ubuntu/Debian.

## How it works

On Linux the LiDE 400 is driven by the **SANE pixma backend**
(`libsane-genesys` does *not* handle this model; pixma does). Support was
added in **sane-backends 1.0.28**, so Ubuntu 20.04 and later work out of
the box. This package:

* pulls in SANE (`libsane1`) and `sane-utils` (`scanimage`),
* installs a udev rule for USB ID `04a9:1912` that tags the device as
  SANE-supported (`ENV{libsane_matched}="yes"`), grants `scanner` group
  access, and keeps USB autosuspend off (the scanner otherwise fails to
  wake up reliably),
* ships documentation and provenance from the Windows driver package
  analysis.

No proprietary Canon binaries are shipped. Nothing is needed from the
Windows driver on Linux.

## Usage

Unplug/reconnect the scanner after installation, then:

    scanimage -L                       # should list: pixma:04A91912 ...
    scanimage --format=png > test.png  # quick flatbed test scan

GUI frontends: `simple-scan` (GNOME Document Scanner), `xsane`,
`gscan2pdf`, `skanlite`. The scanner's EZ buttons are also exposed by the
pixma backend via `scanimage` button options.

High resolution: up to 4800 dpi is supported.

## Troubleshooting

* `scanimage -L` finds nothing:
  * check `lsusb` shows `04a9:1912`;
  * check `getfacl /dev/bus/usb/...` grants your user access, or add
    yourself to the `scanner` group (`sudo usermod -aG scanner $USER`);
  * reload rules: `sudo udevadm control --reload && sudo udevadm trigger`.
* On Ubuntu 18.04 the stock SANE (1.0.27) predates LiDE 400 support;
  install a newer sane-backends (e.g. from a PPA or 20.04+).
* WSL1/WSL2 do not pass through USB devices; use a real Linux host.

## Files

* `/usr/lib/udev/rules.d/60-canoscan-lide400.rules` — udev rules
* `/usr/share/doc/canoscan-lide400-driver/windows-package-provenance.txt`
  — analysis of the original Windows driver installer
