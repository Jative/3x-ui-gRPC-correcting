# xui-grpc-watchdog

**Temporary workaround for the gRPC memory leak in 3x-ui / xray-core.**

3x-ui panels using gRPC inbounds are affected by a memory leak in xray-core that causes RAM usage to grow continuously until the server becomes unresponsive. This watchdog provides a simple, low-overhead mitigation until an upstream fix is available.

---

## How it works

A lightweight bash script runs every minute via a `systemd` timer. It checks the current system RAM usage and, if it exceeds a configurable threshold (default: **80%**), restarts the `x-ui` service and logs the event.

```
systemd timer (every 1 min)
    └─► xui-watchdog.sh
            └─► check RAM usage
                    └─► if > THRESHOLD → x-ui restart → log
```

No daemons. No background processes. Just a one-shot script fired on a schedule.

---

## Requirements

- Linux with `systemd`
- `3x-ui` installed and managed via `x-ui` CLI
- `bash`, `free`, `awk` (standard on all distros)

---

## Installation

```bash
git clone https://github.com/YOUR_USERNAME/xui-grpc-watchdog.git
cd xui-grpc-watchdog
sudo bash install.sh
```

That's it. The timer starts immediately and survives reboots.

---

## Configuration

Open `/usr/local/bin/xui-watchdog.sh` and adjust the threshold:

```bash
THRESHOLD=80  # restart x-ui when RAM usage exceeds this percent
```

After editing, no reload is needed — the script is read fresh on every run.

---

## Verify it's working

Check timer status:
```bash
systemctl status xui-watchdog.timer
```

Watch the log:
```bash
tail -f /var/log/xui-watchdog.log
```

Example log output:
```
Sun Mar 15 03:42:01 UTC 2026: RAM 83% > 80%, restarting x-ui
```

List all systemd timers including this one:
```bash
systemctl list-timers xui-watchdog.timer
```

---

## Uninstall

```bash
sudo bash uninstall.sh
```

The log file at `/var/log/xui-watchdog.log` is preserved.

---

## File structure

```
xui-grpc-watchdog/
├── install.sh
├── uninstall.sh
├── scripts/
│   └── xui-watchdog.sh       # main watchdog script
└── systemd/
    ├── xui-watchdog.service   # oneshot service unit
    └── xui-watchdog.timer     # 1-minute interval timer
```

---

## Background

The gRPC memory leak is a known issue in xray-core. Tracking issues:
- [xray-core #4097](https://github.com/XTLS/Xray-core/issues/4097) *(update with actual issue link)*
- [3x-ui discussions](https://github.com/MHSanaei/3x-ui/discussions)

This repository will be archived or marked obsolete once the upstream issue is resolved. If you know the correct issue links, feel free to open a PR.

---

## Contributing

PRs welcome — especially for:
- Per-process memory check (target only the `x-ui` / `xray` process instead of total RAM)
- Telegram or other notification on restart
- Correct upstream issue links

---

## License

MIT
