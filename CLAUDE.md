# CLAUDE.md

This is the **Project_Structure** scaffolding generator — a template tree plus
Bash scripts that stamp out a numbered, matched-folder bioinformatics project
layout. It is **not itself an analysis project** (the `01-…`/`05-…` folders live
under `templates/`, not at this repo's root).

## Repo layout
- `templates/` — the exact tree and starter `.md` files that generated projects receive.
- `scripts/*.sh` — `create_project_structure.sh`, `add_project_to_existing.sh`,
  and `add_analysis_to_project.sh` copy from `templates/` into a target directory.
- `templates/CLAUDE.md` — **the conventions doc that ships into every generated
  project's root.** Read it to understand the folder-and-number rules those
  projects follow (where scripts/data/analysis/reports go, which `.md` docs to
  generate, and how `01-documentation/` metadata is maintained).

## When editing this repo
- Keep `scripts/`, `templates/`, and `README.md` **in sync** — a change to the
  structure usually touches all three (and often `templates/CLAUDE.md`).
- After changing scripts or templates, run the smoke test locally the same way CI
  does (see `.github/workflows/test.yml`): scaffold a project in a temp dir and
  assert the tree.
- Shell scripts must stay `shellcheck`-clean (CI enforces it) and start with
  `set -euo pipefail`.
- Use Conventional Commits (`feat:`, `fix:`, `docs:`, `chore:`); releases are
  automated by release-please — see `RELEASING.md`.
