# AGENTS.md - Instructions for AI Agents

## Project Overview
This repo builds a **bootable container image** (bootc) for **k0s** Kubernetes on Fedora.

## Key Files
- `Containerfile` - Main build file (FROM fedora-bootc, installs k0s + tools)
- `kickstart.ks` - Anaconda kickstart for bare-metal install
- `config/k0s.yaml` - k0s cluster configuration
- `config/firstboot.sh` / `config/firstboot.service` - First-boot init scripts
- `tests/structure-test.yaml` - container-structure-test assertions
- `.github/workflows/lint_and_build.yaml` - CI pipeline

## Important Rules
- **NEVER touch `K0S_VERSION` or `CRI_TOOLS_VERSION`** in `Containerfile` - these are managed separately
- When updating Fedora base: change the `FROM` line in `Containerfile` and verify all pinned package versions exist on the new release
- To check package versions in a Fedora release: `podman run --rm quay.io/fedora/fedora-bootc:<version> dnf list --showduplicates <pkg>`
- Always pin specific package versions in ARGs (never use unversioned `dnf install`)
- Keep ARGs in alphabetical order in Containerfile
- Run `hadolint Containerfile` to lint after changes
- The k0s version is defined in `Containerfile` and used in CI for image tagging
- Branch naming: use lowercase with hyphens (e.g. `fedora-44`)

## Dependency Pinning Strategy
- All `dnf install` commands use version-pinned ARGs
- For `curl`-installed packages (like tailscale repo), version is pinned in the `dnf install` step
- `k9s` is installed from GitHub latest release (not pinned)
- Packages in the "other tools" layer (fish, htop, etc.) should use unversioned `dnf install` to let the base image resolve them

## Testing
- Lint: `hadolint Containerfile`
- Structure tests: `container-structure-test test --image <image> --config tests/structure-test.yaml`
- CI runs on push to main/develop and PRs to main
