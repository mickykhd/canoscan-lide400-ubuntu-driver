# Canon CanoScan LiDE 400 — Ubuntu/Debian driver package (deb)

A driver enablement **.deb** for the **Canon CanoScan LiDE 400** USB flatbed
scanner on Ubuntu/Debian, created from static analysis of Canon's Windows
driver package `win-lide400-1_2-n_mcd.exe`.

## Why

Canon ships Windows/macOS drivers only. On Linux the LiDE 400 is natively
driven by the **SANE pixma backend** (added in sane-backends 1.0.28), but
users frequently hit permission/autosuspend issues or run distributions
whose SANE predates support. This package makes installation a one-step
operation and guarantees udev handling.

## What the analysis found (Windows package)

| Property | Value |
|---|---|
| Source file | `win-lide400-1_2-n_mcd.exe` (20,772,992 bytes) |
| SHA-256 | `963BAA0D2F521B89E40176C4EC59C5634256B6879444E4D0E0C51EC237B3C03C` |
| Format | PE32 WinZip Self-Extractor (`_winzip_` section at `0x39000`) |
| Embedded ZIP | 447 entries, SHA-256 `965066fba51867a0dd27e75b2646b23f056f8a89f28bdad104a9761749a680ef` |
| Identity | Canon CD-1803-000320, driver v1.2, type N_MCD(Win) |
| Target OS | Windows 7 SP1 – Windows 11, x86/x64 |
| Notable | Online installer stub: `win/Driver/` is empty, components referenced via `FILE_ONLINE` are downloaded during install |

## Linux driver mapping

| Property | Value |
|---|---|
| USB ID | `04a9:1912` |
| Backend | SANE **pixma** (not genesys) |
| Support since | sane-backends **1.0.28** ("pixma: Added Canon LiDE 400") |
| Status | Complete — all resolutions up to 4800 dpi |
| Verified against | Ubuntu 24.04 libsane 1.2.1-7build4 (hwdb `usb:v04A9p1912*` + backend strings) |

## Install

Download the .deb from the [releases page](../../releases), then:

```bash
sudo apt install ./canoscan-lide400-driver_1.2-1_all.deb
scanimage -L                      # expect: pixma:04A91912 ...
scanimage --format=png > test.png # quick test scan
```

Requires Ubuntu 20.04 or newer (sane-backends >= 1.0.28). GUI frontends:
`simple-scan`, `xsane`, `gscan2pdf`, `skanlite`.

## Package contents

- `/usr/lib/udev/rules.d/60-canoscan-lide400.rules` — tags the scanner as
  SANE-supported (`libsane_matched`), grants `scanner` group access,
  disables USB autosuspend
- `postinst` — reloads udev and verifies the installed SANE advertises
  LiDE 400 support
- Docs — README, provenance record of the Windows package analysis, copyright

No proprietary Canon files are redistributed; everything here was authored
from public SANE documentation and static analysis. "CanoScan" and "LiDE"
are trademarks of Canon Inc.; this project is not affiliated with Canon.

## Build

The .deb is built from `deb-src/` on any Ubuntu/WSL machine:

```bash
wsl bash /mnt/d/Projects/personal/canoscan/deb-src/build.sh
```

Layout:

```
deb-src/
├── build.sh                       # builds the deb via dpkg-deb
└── canoscan-lide400-driver/
    ├── DEBIAN/{control,postinst}
    └── usr/
        ├── lib/udev/rules.d/60-canoscan-lide400.rules
        └── share/doc/canoscan-lide400-driver/{README.md,copyright,windows-package-provenance.txt}
```

## License

MIT for the packaging files in this repository (see
`deb-src/canoscan-lide400-driver/usr/share/doc/canoscan-lide400-driver/copyright`).