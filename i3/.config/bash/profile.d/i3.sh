# Sourced by ~/.bashrc on the Debian + i3 (X11) setup.

# neovim installed from the upstream tarball
export PATH="$PATH:/opt/nvim/bin"

# brew
[ -x /home/linuxbrew/.linuxbrew/bin/brew ] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Automatically mirror displays if a second monitor is connected
if [ -n "$DISPLAY" ] && command -v xrandr > /dev/null; then
    # Get the primary monitor (first connected monitor)
    PRIMARY_MONITOR=$(xrandr | grep " connected primary" | cut -d' ' -f1)

    # If no primary monitor is found, find the first connected monitor
    if [ -z "$PRIMARY_MONITOR" ]; then
        PRIMARY_MONITOR=$(xrandr | grep " connected" | head -n 1 | cut -d' ' -f1)
    fi

    # Get the second connected monitor (if any)
    SECONDARY_MONITOR=$(xrandr | grep " connected" | grep -v "$PRIMARY_MONITOR" | head -n 1 | cut -d' ' -f1)

    # If both monitors are connected, mirror the primary monitor to the secondary
    if [ -n "$SECONDARY_MONITOR" ]; then
        xrandr --output "$PRIMARY_MONITOR" --auto --output "$SECONDARY_MONITOR" --auto --same-as "$PRIMARY_MONITOR"
    fi
fi

# >>> conda initialize >>>
if [ -x "$HOME/miniconda3/bin/conda" ]; then
    __conda_setup="$("$HOME/miniconda3/bin/conda" 'shell.bash' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    elif [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/miniconda3/bin:$PATH"
    fi
    unset __conda_setup
fi
# <<< conda initialize <<<
