# Tom's Neovim 2025

[NVIM_APPNAME](https://neovim.io/doc/user/starting.html#%24NVIM_APPNAME) is used to isolate install.
neovim v0.10.0+ is required.

### Install

```bash

git clone https://github.com/tsaeger/dotvim.git ~/.config/nvim2025

cat <<'EOF' > ~/.local/bin/nv ; chmod +x ~/.local/bin/nv
#!/usr/bin/env bash
# Launch neovim config from
# isolated area specified by NVIM_APPNAME
# :help NVIM_APPNAME

# shellcheck disable=SC2068
NVIM_APPNAME="nvim2025" nvim \
    $@
EOF

## Install pynvim to dedicated virtualenv

cargo install --git https://github.com/astral-sh/uv uv
cd ~/.config
uv venv --python 3.12 nvim2025.venv
source nvim2025.venv/bin/activate
uv pip install pynvim

```

### References

- [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
- [![Neovim kickstart from TJ DeVries](https://img.youtube.com/vi/m8C0Cq9Uv9o/0.jpg)](https://youtu.be/m8C0Cq9Uv9o)
- [neovim-kickstart-config](https://github.com/hendrikmi/neovim-kickstart-config)
- [![Full Neovim Setup from Scratch in 2025](https://img.youtube.com/vi/KYDG3AHgYEs/0.jpg)](https://youtu.be/KYDG3AHgYEs?si=I71UjuoQg2fHLGyu)
