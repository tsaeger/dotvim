# Common commands for the standalone Neovim runtime and configuration.
# Run `just` to list recipes.
set shell := ["bash", "-euo", "pipefail", "-c"]
set quiet

# Choose a recipe interactively.
default:
  @just --choose

# Evaluate and build the flake checks.
check:
  nix flake check

# Build the standalone Neovim runtime.
build:
  nix build .#nvim

# Run the headless plugin smoke test against the Nix-built Neovim.
smoke:
  NVIM=$(nix build .#nvim --print-out-paths)/bin/nvim test/smoke.sh

# Run the terminal Neovim runtime.
run *args:
  nix run .#nvim -- {{args}}

# Run the Neovide runtime.
neovide *args:
  nix run .#neovide -- {{args}}

# Build the Tier-1 tools environment.
tools:
  nix build .#tools

# Remove local build result symlinks.
clean:
  rm -f result result-*

# Show locked revisions for direct flake inputs.
versions:
  @jq -r '. as $lock | $lock.nodes.root.inputs | to_entries[] | .key as $name | .value as $node | [$name, ($lock.nodes[$node].locked.rev // "-")] | @tsv' flake.lock | column -t -s $'\t'

# Compare locked revisions with freshly resolved upstream revisions.
outdated:
  #!/usr/bin/env bash
  set -euo pipefail
  latest=$(mktemp)
  urls=$(mktemp)
  trap 'rm -f "$latest" "$urls"' EXIT
  nix flake update --output-lock-file "$latest" >/dev/null
  printf '%-24s %-12s %-12s %8s  %s\n' INPUT CURRENT LATEST COMMITS SUMMARY
  while IFS= read -r input; do
    current_node=$(jq -r --arg i "$input" '.nodes.root.inputs[$i]' flake.lock)
    latest_node=$(jq -r --arg i "$input" '.nodes.root.inputs[$i]' "$latest")
    current=$(jq -r --arg n "$current_node" '.nodes[$n].locked.rev // "-"' flake.lock)
    next=$(jq -r --arg n "$latest_node" '.nodes[$n].locked.rev // "-"' "$latest")
    [[ "$current" == "$next" ]] && continue
    owner=$(jq -r --arg n "$current_node" '.nodes[$n].locked.owner // empty' flake.lock)
    repo=$(jq -r --arg n "$current_node" '.nodes[$n].locked.repo // empty' flake.lock)
    current_date=$(jq -r --arg n "$current_node" '.nodes[$n].locked.lastModified // 0' flake.lock)
    latest_date=$(jq -r --arg n "$latest_node" '.nodes[$n].locked.lastModified // 0' "$latest")
    current_date=$(jq -nr --argjson ts "$current_date" '$ts | todateiso8601 | split("T")[0]')
    latest_date=$(jq -nr --argjson ts "$latest_date" '$ts | todateiso8601 | split("T")[0]')
    if [[ -n "$owner" && -n "$repo" ]]; then
      if comparison=$(gh api "repos/$owner/$repo/compare/$current...$next" --jq '[.ahead_by, (.commits[-1].commit.message // "" | split("\n")[0]), .html_url] | @tsv' 2>/dev/null); then
        IFS=$'\t' read -r commits summary url <<<"$comparison"
        printf '%-24s %-12s %-12s %8s  %s\n' "$input" "$current_date" "$latest_date" "$commits" "$summary"
        printf '%s\t%s\n' "$input" "$url" >> "$urls"
      else
        printf '%-24s %-12s %-12s %8s  %s\n' "$input" "$current_date" "$latest_date" '?' 'GitHub comparison unavailable'
      fi
    else
      printf '%-24s %-12s %-12s %8s  %s\n' "$input" "$current_date" "$latest_date" '?' 'non-GitHub source'
    fi
  done < <(jq -r '.nodes.root.inputs | keys[]' flake.lock)
  if [[ -s "$urls" ]]; then
    printf '\nCOMPARE URLS\n'
    while IFS=$'\t' read -r input url; do
      printf '%-24s %s\n' "$input" "$url"
    done < "$urls"
  fi

# Update this flake's inputs.
update:
  nix flake update

# Enter the development shell.
shell:
  nix develop
