# Install packages and link the dotfiles; extra args go to ansible-playbook
# (e.g. `just setup -e wm=i3`, `just setup --check`)
setup *args:
    ansible-playbook ansible/playbook.yml -K {{args}}

# Runs outside Ansible so sudo can prompt for a password; the package list
# lives in ansible/vars/Archlinux.yml (pwn_packages)
# Install the ethical hacking / CTF tools with paru (Arch only)
pwn:
    #!/usr/bin/env bash
    set -euo pipefail
    if ! command -v paru >/dev/null; then
        tmp="$(mktemp -d)"
        git clone https://aur.archlinux.org/paru-bin.git "$tmp/paru-bin"
        (cd "$tmp/paru-bin" && makepkg -si --noconfirm)
    fi
    pkgs="$(python3 -c "import yaml; print(' '.join(yaml.safe_load(open('ansible/vars/Archlinux.yml'))['pwn_packages']))")"
    paru -S --needed --noconfirm --skipreview $pkgs
