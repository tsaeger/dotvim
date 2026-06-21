#!/usr/bin/env bash
set -euo pipefail

VENV_DIR="/Volumes/workspace/neovim/nvim2025.venv"
PYTHON_VERSION="3.13"

if ! command -v uv >/dev/null 2>&1; then
	printf 'error: uv is not installed or not on PATH\n' >&2
	exit 1
fi

printf 'Removing %s\n' "$VENV_DIR"
rm -rf "$VENV_DIR"

printf 'Creating Python %s venv at %s\n' "$PYTHON_VERSION" "$VENV_DIR"
uv venv --python "$PYTHON_VERSION" "$VENV_DIR"

printf 'Installing Neovim Python modules\n'
uv pip install --python "$VENV_DIR/bin/python" pynvim neovim

printf '\nVerification\n'
"$VENV_DIR/bin/python" --version
"$VENV_DIR/bin/python" -c "import neovim, pynvim; print('pynvim', pynvim.__version__); print('neovim module ok')"

printf '\nNeovim python3_host_prog:\n%s/bin/python\n' "$VENV_DIR"
