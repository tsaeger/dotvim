# Tom's Neovim 2025

### Install

```bash

tar -C ~/.config -axf nvim2025.tar

cat <<'EOF' > ~/.local/bin/nv ; chmod +x ~/.local/bin/nv
#!/usr/bin/env bash
# Launch neovim config from
# isolated area specified by NVIM_APPNAME
# :help NVIM_APPNAME

# shellcheck disable=SC2068
NVIM_APPNAME="nvim2025" nvim \
    $@
EOF

## neovim python install

cargo install --git https://github.com/astral-sh/uv uv
cd ~/.config
uv venv --python 3.12 nvim2025.venv
source nvim2025.venv/bin/activate
uv pip install pynvim

```

### References

[kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
[neovim-kickstart-config](https://github.com/hendrikmi/neovim-kickstart-config)
[Neovim kickstart from TJ DeVries](https://www.youtube.com/watch?v=m8C0Cq9Uv9o&t=103s)
[![Full Neovim Setup from Scratch in 2025](https://img.youtube.com/vi/KYDG3AHgYEs/0.jpg)](https://youtu.be/KYDG3AHgYEs?si=I71UjuoQg2fHLGyu)
