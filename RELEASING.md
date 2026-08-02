# Releasing

Releases are automated with
[release-please](https://github.com/googleapis/release-please). You never bump a
version or write `CHANGELOG.md` by hand — the version is derived from
[Conventional Commit](https://www.conventionalcommits.org/) messages.

## How it works

1. Push commits to `main` using conventional prefixes:
   - `feat:` → minor bump (new capability), listed under **Added**
   - `fix:` → patch bump, listed under **Fixed**
   - `docs:`, `refactor:`, `perf:` → shown in the changelog (no bump on their own)
   - `chore:`, `ci:`, `test:`, `build:` → hidden from the changelog
   - append `!` or a `BREAKING CHANGE:` footer for a major bump
2. The **release-please** workflow opens (or updates) a *release PR* that bumps
   the version in `.release-please-manifest.json` and updates `CHANGELOG.md`.
3. **Merge that PR.** release-please then creates the git tag (`vX.Y.Z`) and a
   GitHub Release with the generated notes.

There is no package-registry step — this repository ships scripts and a template
tree, so the GitHub Release *is* the published artifact. (The sibling
`spatioloji_s` repo additionally uploads to PyPI; that stage is intentionally
omitted here.)

## One-time setup

- **Settings → Actions → General → Workflow permissions**: enable
  *"Allow GitHub Actions to create and approve pull requests"* — otherwise
  release-please cannot open the release PR.

## Notes

- release-please runs on exactly one branch (`main`). Do not enable it on a
  second branch or it will open competing release PRs.
- The first release considers commits made *after* `bootstrap-sha` in
  `release-please-config.json` (the repo's state when this automation landed).
- To cut the first release, land at least one `feat:` or `fix:` commit on `main`.
