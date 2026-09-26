Setup

Install packages and link the configs with the Ansible playbook
(Arch or Debian/Ubuntu/Pop!_OS; needs `ansible`, not just `ansible-core`):

    git clone https://github.com/n3tw0rth/dotfiles.git ~/.dotfiles
    cd ~/.dotfiles
    ansible-playbook ansible/playbook.yml -K             # auto-detect sway or i3
    ansible-playbook ansible/playbook.yml -K -e wm=i3    # force sway or i3
    ansible-playbook ansible/playbook.yml -K --check     # dry run

Package names per distro live in ansible/vars/. On Debian-based systems a few
tools come from snap or upstream releases; picom (i3) is built from its next
branch there, and i3lock-color is built from source on both.

The playbook finishes by running ./stow.sh, which can also be run on its own
to relink without installing anything:

    ./stow.sh          # auto-detect sway or i3
    ./stow.sh sway     # force sway (Wayland)
    ./stow.sh i3       # force i3 (X11)

The repo is split into stow packages; ./stow.sh links `common` plus the
package for the setup, and removes leftover links from the other one:

- common/: shell, tmux, git, nvim, starship, terminator (every setup)
- sway/:   Arch + sway (Wayland) - .config/sway
- i3/:     Debian + i3 (X11) - .config/i3, i3blocks, polybar, picom,
           xinputconfig.sh

Setup-specific shell config goes in `<package>/.config/bash/profile.d/*.sh`,
which ~/.bashrc sources (e.g. i3/ has xrandr mirroring, linuxbrew, conda).

Detection (both the playbook and stow.sh): a Wayland session picks sway, an
X11 session picks i3. From a TTY, pass the window manager explicitly to the
playbook; stow.sh falls back to whichever of sway/i3 is installed.



Apps and Tools

- pop os
- neovim - text editor (nvChad)
- lazygit - git commands
- terminator - terminal
- i3wm - tiling window manager (X11)
- sway - tiling window manager (Wayland), config ported from
  https://github.com/n3tw0rth/nix-config
    - mod key is Alt, bar is swaybar styled like the nix-config waybar
      (status from .config/sway/status.py)
    - grim, slurp, wl-clipboard, jq - screenshots
    - ttf-jetbrains-mono-nerd - bar font
- i3-lock
- betterlockscreen
- i3lock-color
- feh - image viewer
- picom - X11 compositor
- tmux - terminal multiplexer
- yazi - file browser
- caja - file browser
- polybar - status bar (i3)
- starship - shell prompts
- firefox
- k9s - manage k8s
- minikube - k8s
- miam - screenshots
- docker
- postman
- radare



Languages

- rust 
- node
    - nvm
    - yarn,pnpm
- python
    - miniconda
