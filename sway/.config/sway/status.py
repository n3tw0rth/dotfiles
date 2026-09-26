#!/usr/bin/env python3
# swaybar status_command (i3bar JSON protocol), mirroring the waybar modules in
# https://github.com/n3tw0rth/nix-config (modules/common/waybar.nix).
# Left click on volume lowers it 5%, right click raises it 5%.

import glob
import json
import os
import select
import shutil
import signal
import subprocess
import sys
import time

INTERVAL = 5
DIM = "#555555"


def run(*cmd):
    try:
        return subprocess.run(cmd, capture_output=True, text=True, timeout=2).stdout
    except (OSError, subprocess.TimeoutExpired):
        return ""


def block(name, text, color=None):
    b = {"name": name, "full_text": text, "separator": False, "separator_block_width": 20}
    if color:
        b["color"] = color
    return b


def battery():
    bats = glob.glob("/sys/class/power_supply/BAT*")
    if not bats:
        return None
    read = lambda f: open(os.path.join(bats[0], f)).read().strip()
    cap, status = int(read("capacity")), read("status")
    label = {"Charging": "CHR", "Full": "AC", "Not charging": "AC"}.get(status, "BAT")
    color = None
    if label == "BAT":
        color = "#ffffff" if cap <= 15 else "#999999" if cap <= 30 else None
    return block("battery", f"{label} {cap}%", color)


def network():
    for line in run("nmcli", "-t", "-f", "TYPE,STATE,CONNECTION", "device").splitlines():
        kind, state, conn = (line.split(":", 2) + ["", ""])[:3]
        if state != "connected":
            continue
        if kind == "wifi":
            for w in run("nmcli", "-t", "-f", "ACTIVE,SIGNAL", "device", "wifi").splitlines():
                if w.startswith("yes:"):
                    return block("network", f"WIFI {conn} {w.split(':')[1]}%")
            return block("network", f"WIFI {conn}")
        if kind == "ethernet":
            return block("network", "ETH")
    return block("network", "OFFLINE", DIM)


def disk():
    u = shutil.disk_usage("/")
    return block("disk", f"DISK {round(u.used * 100 / u.total)}%")


def volume():
    if run("pactl", "get-sink-mute", "@DEFAULT_SINK@").strip().endswith("yes"):
        return block("volume", "MUTE", DIM)
    out = run("pactl", "get-sink-volume", "@DEFAULT_SINK@")
    pct = next((w for w in out.split() if w.endswith("%")), None)
    if pct is None:  # no sound server
        return None
    return block("volume", f"VOL {pct}")


def clock():
    return block("clock", time.strftime("%a %d %b  %H:%M"))


def status():
    blocks = [battery(), network(), disk(), volume(), clock()]
    return [b for b in blocks if b]


def handle_click(line):
    line = line.strip().lstrip(",")
    if not line or line == "[":
        return False
    try:
        ev = json.loads(line)
    except ValueError:
        return False
    if ev.get("name") != "volume":
        return False
    step = {1: "-5%", 3: "+5%"}.get(ev.get("button"))
    if step:
        run("pactl", "set-sink-volume", "@DEFAULT_SINK@", step)
    return True


def main():
    signal.signal(signal.SIGPIPE, signal.SIG_DFL)  # exit quietly when swaybar goes away
    print(json.dumps({"version": 1, "click_events": True}))
    print("[")
    stdin_open = True
    while True:
        print(json.dumps(status()) + ",", flush=True)
        if not stdin_open:
            time.sleep(INTERVAL)
            continue
        ready, _, _ = select.select([sys.stdin], [], [], INTERVAL)
        if ready:
            line = sys.stdin.readline()
            if line:
                handle_click(line)
            else:
                # stdin closed; keep updating on the timer
                stdin_open = False


if __name__ == "__main__":
    main()
