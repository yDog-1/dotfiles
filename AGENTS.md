# Repository Guidelines

## Project Structure & Module Organization
Dotfiles live under `dot_config/`; treat each subdirectory as an isolated feature. The Nix flake in `dot_config/home-manager/` (`flake.nix`, `home.nix`, `modules/`) maps feature flags to packages and services—update module dependencies in tandem to avoid drift. Neovim lives in `dot_config/nvim/`; keep plugin specs in `lua/plugins/` small and pair edits with lockfile updates. Terminal tooling spans `dot_config/zellij/`, `dot_config/wezterm/`, and `dot_config/zeno/`; keep options aligned with the Home Manager modules. Agent collateral sits in `dot_config/opencode/`; raise a peer review before landing changes to `AGENTS.md` or prompt decks.

## Build, Test, and Development Commands
`chezmoi diff` previews pending dotfile edits against the live system. Run `chezmoi apply --dry-run` to validate changes without applying them. `nix flake check` lint-checks the flake inputs and Home Manager modules. `nix build .#homeConfigurations.ydog-1.activationPackage && ./result/activate` exercises activation scripts safely. `nvim --headless "+Lazy! sync" +qa` refreshes Neovim plugins and lockfiles.

## Coding Style & Naming Conventions
Indent Nix and Lua with two spaces and match existing brace alignment or Japanese commentary. Format Nix via `alejandra`, Lua with `stylua`, and JSON/TOML using `biome`, `dprint`, or `prettier` to mirror repo conventions. Author shell scripts for Bash with `#!/bin/bash`, `set -e`, guarded reads, and lower_snake_case helpers; place new bootstraps under `executable_*.sh`.

## Testing Guidelines
Lint shell scripts with `bash -n script.sh` and add `shellcheck` locally when available. After touching language tooling or Neovim plugins, run `nix flake check`, `nvim --headless "+MasonUpdate" +qa`, and `nvim --headless "+Lazy! sync" +qa`. Use `yamllint dot_config/yamllint` and `markdownlint-cli AGENTS.md` to keep YAML and documentation sane.

## Commit & Pull Request Guidelines
Follow Conventional Commits—scope with top-level directories (e.g., `feat(nvim): add gofmt integration`). Keep commits focused, link issues, and include screenshots for UI or terminal theming changes. Capture command output such as `chezmoi diff` and `nix flake check` in PR descriptions, and flag any updates under `dot_config/opencode/` for rehearsal.

## Security & Configuration Tips
Never commit secrets; prefer `chezmoi secret` or local templates for credentials. When bumping remote pins in `flake.nix`, record upstream revisions, verify hashes, and mention the validation steps in the PR.
