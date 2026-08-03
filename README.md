# 🧬 Bioinformatics Project Directory Structure

[![DOI](https://zenodo.org/badge/1017777377.svg)](https://doi.org/10.5281/zenodo.21763803)
[![Test scripts](https://github.com/gynecoloji/Project_Structure/actions/workflows/test.yml/badge.svg)](https://github.com/gynecoloji/Project_Structure/actions/workflows/test.yml)
[![Release](https://img.shields.io/github/v/release/gynecoloji/Project_Structure)](https://github.com/gynecoloji/Project_Structure/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A reusable, **script-driven template** for organizing complex, multi-step
bioinformatics analyses — multiple sequencing data types, multiple projects, and
many sub-analyses — in a consistent, reproducible, and Claude-Code-friendly
layout. Instead of hand-rolling folders for every study, run one script and get a
fully scaffolded project with **matched, numbered folders** and ready-to-fill
**Markdown documentation**.

---

## ✨ What this gives you

- **🔢 Numbered, matched folders** — within a project, every analysis has a number
  (`01_`, `02_`, …) reused across its scripts and results, so related work lines up.
- **📝 Markdown-first docs** — scaffolding drops in real starter files (summaries,
  `params.json`, metadata tables) instead of empty placeholders.
- **⚙️ One-command scaffolding** — create a project, add a project code, or add an
  auto-numbered analysis with a single script.
- **🐍 Reproducible by default** — a conda `environment.yml`, a tools/versions
  table, and a data-provenance log ship with every project.
- **🤖 Claude Code aware** — each project includes a `CLAUDE.md` so Claude Code
  knows where to save outputs and which docs to generate (no API needed).
- **✅ CI + automated releases** — `shellcheck` + smoke tests on every push, and
  versioning/changelogs handled by release-please.

---

## 🚀 Quick start

```bash
# 1. Get the template and make the scripts runnable
git clone https://github.com/gynecoloji/Project_Structure.git
cd Project_Structure
chmod +x scripts/*.sh

# 2. Scaffold a new project (code 01) in a directory of your choice.
#    The 4th argument names the first analysis (→ folder 01_diff_expression).
./scripts/create_project_structure.sh 01 "Bulk RNA-seq tumor vs normal" ~/projects/my_study diff_expression

# 3. Add a second project code (02) to the same workspace
./scripts/add_project_to_existing.sh 02 "Bulk ATAC-seq tumor vs normal" ~/projects/my_study

# 4. Add another analysis to project 01 — auto-numbered 02_, 03_, …
./scripts/add_analysis_to_project.sh 01 motif_analysis ~/projects/my_study
```

> Omit the trailing path to scaffold in the current directory. Point the scripts at
> where your project should live — **not** inside this repo, so you don't scaffold
> on top of the templates. Re-running with an existing project code is refused so
> you can't overwrite work.

**Then just work in the project.** Open it with Claude Code (`cd ~/projects/my_study && claude`) and it reads the bundled `CLAUDE.md` automatically — see [Working with Claude Code](#-working-with-claude-code). To reproduce the software environment:

```bash
conda env create -f 01-documentation/environment.yml
```

---

## 🗂️ What gets created

```
my_study/
├── CLAUDE.md             # Claude Code guidance: where outputs go + which .md docs to write
├── 01-documentation/     # metadata, sample sheet, tool versions, data sources, logs
├── 02-scripts/           # number-prefixed scripts, per project
├── 03-data/              # Raw / Processed / Reference_Data, per project
├── 04-analysis/          # numbered analyses → dated runs → figures/results/logs
├── 05-reports/           # per-project .pptx + .md summary of the analyses
└── upstream_workflows/   # optional, created manually
```

---

## 📌 Key concepts

- **Project Code (e.g. `01`)**: Ties everything for one project together — `01-documentation/Metadata_01.md`, `02-scripts/Script_01/`, `03-data/Data_01/`, `04-analysis/Analysis_01/`, and `05-reports/Analysis_01/` all refer to the **same project**.
- **Analysis number (`01_`, `02_`, …)**: Within a project, each downstream analysis gets a two-digit number and short name (e.g. `01_diff_expression`), reused across `02-scripts/` (script prefix) and `04-analysis/` (analysis folder) so a script and its results line up. Reports are a single per-project summary (see `05-reports/`).
- **Run folders**: Timestamped subfolders (`YYYY-MM-DD_run`) for each independent run of an analysis.

> All documentation lives in `.md` files so it renders nicely on GitHub; tabular data stays as `.tsv`, parameters as `.json`, and run logs as `.log`.

---

## 📁 Folder reference

### 📁 01-documentation/ — Metadata, Logs & Sample Info

> Key metadata and contextual info for the entire workspace.

- `Metadata_summary.md`: High-level index of all projects and purposes.
- `Metadata_<project>.md`: Detailed info for each project.
- `sample_sheet.tsv`: Sample-to-condition mapping for each run.
- `data_sources.md`: Download URLs, versions, checksums for external data.
- `tools_versions.md`: Human-readable table of tools & versions.
- `environment.yml`: Conda environment spec — `conda env create -f 01-documentation/environment.yml`.
- `experiment_log.md`: Manual notes on important steps and decisions.
- `README.md`: Explains the documentation folder.
- `design_diagrams/`: (Optional) pipeline/data-flow figures.

### 📁 02-scripts/ — Scripts Per Project

> All scripts (R, Python, shell) related to analyses in this project.

```
02-scripts/
└── Script_<project_code>/
    ├── script_summary.md
    ├── 01_preprocess_counts.R   # analysis 01_<name>
    ├── 01_run_deseq2.R          # analysis 01_<name>
    └── 02_motif_analysis.sh     # analysis 02_<name>
```

- Prefix each script with its analysis number so it lines up with `04-analysis/` and `05-reports/`. Several scripts can share a number if they feed the same analysis.
- Describe every script in `script_summary.md`.
- Keep scripts modular and use relative paths for portability.

### 📁 03-data/ — Input Data (Raw, Processed, References)

> All data used for downstream analysis, organized per project.

```
03-data/
└── Data_<project_code>/
    ├── Raw/              # Upstream outputs: counts, BAMs, peaks
    ├── Processed/        # Cleaned objects (AnnData, Seurat, tsv) + README.md
    └── Reference_Data/   # Genomes, GTFs, motifs, DBs
```

- Never alter files in `Raw/`; access them via symlinks or config.
- Track sources in `01-documentation/data_sources.md`.
- Large data (`Raw/`, `Reference_Data/`, BAMs, FASTQs, `.rds`, …) is kept out of git by `.gitignore`.

### 📁 04-analysis/ — Results, Figures, Parameters

> All downstream analysis, organized by project, then numbered analysis, then run.

```
04-analysis/
└── Analysis_<project_code>/
    ├── overview.md          # objectives, analysis index, key findings
    ├── QC/
    ├── 01_<name>/
    │   ├── analysis.log
    │   └── YYYY-MM-DD_run/
    │       ├── figures/
    │       ├── results/
    │       ├── logs/
    │       ├── params.json
    │       └── summary.md
    └── 02_<name>/
        └── ...
```

- Each numbered analysis (`01_<name>`, `02_<name>`, …) matches a script prefix in `02-scripts/`; the whole project is summarized in `05-reports/Analysis_<project_code>/`.
- Each `run/` folder is a self-contained run with its own logs and outputs.
- Use `summary.md` to record input data (paths), parameters, scripts used, and key findings.

### 📁 05-reports/ — Presentations & Communication

> One presentation-ready summary per project — **only `.pptx` and `.md` files, no subfolders**.

```
05-reports/
└── Analysis_<project_code>/
    ├── report_summary.md                        # Markdown summary of the project's analyses
    └── Analysis_<project_code>_summary.pptx      # slide deck
```

- **Only `.pptx` and `.md` files** here, summarizing the analytical results from `04-analysis/Analysis_<project_code>/`. **Do not create subfolders.**
- Presentations only — no raw or intermediate data.
- Copy final figures from `04-analysis/.../<NN>_<name>/.../figures/` into the deck / summary.

### 📁 upstream_workflows/ — Pipelines for Raw Data Processing

> Each subfolder corresponds to a data type with its own workflow.

```
upstream_workflows/
├── scRNAseq/
├── bulkRNAseq/
├── bulkATACseq/
├── bulkChIPseq/
├── bulkCutAndRun/
└── shared_references/
```

- ⚠️ This folder is **optional and is not created by the setup scripts** — add it manually if your workflow needs a separate raw-data-processing stage.
- Final outputs (e.g. count matrices) are transferred to `03-data/Data_<project_code>/Raw/`.
- `shared_references/` holds indexed genomes, motifs, GTFs, etc. shared across pipelines.

---

## 🔄 Workflow flowchart

```
upstream_workflows/       →     03-data/
    (by data type)         →     (Raw, Reference_Data)
                                     ↓
                              04-analysis/
                                     ↓
                              05-reports/
```

Documentation and tracking across all steps is maintained in `01-documentation/`.

---

## 🤖 Working with Claude Code

Every generated project ships a root **`CLAUDE.md`**. When you open the project
with [Claude Code](https://claude.com/claude-code) (`claude` in the project
directory), it loads those conventions automatically and will:

- save scripts, data, and analysis outputs to the **correct matched folders**
  (same number across `02-scripts/` and `04-analysis/`; a single summary per
  project in `05-reports/Analysis_<code>/`);
- generate the matching **Markdown docs** — `script_summary.md`, run `summary.md`,
  `Processed/README.md`, and the `05-reports/` `report_summary.md`;
- keep **`01-documentation/` metadata** current (sample sheet, data sources, tool
  versions, experiment log).

No API key or extra setup required — it's plain project memory that Claude Code reads.

---

## 🏷️ Versioning & releases

Releases are automated with [release-please](https://github.com/googleapis/release-please)
from [Conventional Commits](https://www.conventionalcommits.org/):

- Push `feat:` / `fix:` commits to `main` → release-please opens a **release PR**
  that bumps the version and updates `CHANGELOG.md`.
- Merge that PR → it tags `vX.Y.Z` and publishes a GitHub Release.

CI (`.github/workflows/test.yml`) lints the scripts with `shellcheck` and
smoke-tests that they still scaffold a valid project. See **[RELEASING.md](RELEASING.md)**
for the full flow and the one-time repo setting.

---

## 🧰 Automation cheatsheet

| Task | Tool/Script |
|------|-------------|
| Initialize a new project | `scripts/create_project_structure.sh <code> "<desc>" [dir] [analysis_name]` |
| Add another project code | `scripts/add_project_to_existing.sh <code> "<desc>" [dir] [analysis_name]` |
| Add a numbered analysis (auto 02, 03, …) | `scripts/add_analysis_to_project.sh <code> <name> [dir]` |
| Log tool versions | `conda list > 01-documentation/tools_versions.md` |
| Recreate the conda environment | `conda env create -f 01-documentation/environment.yml` |
| Track project-wide metadata | Auto-appended to `Metadata_summary.md` by the scripts |
| Backup to cloud | `rclone sync` (exclude intermediate files) |

---

## ✅ Folder role summary

| Folder | Role |
|--------|------|
| `01-documentation/` | Metadata, logs, source tracking, versioning |
| `02-scripts/` | Reproducible, number-prefixed scripts per project |
| `03-data/` | All raw, processed, and reference input data |
| `04-analysis/` | Numbered analyses, runs, results and summaries |
| `05-reports/` | Per-project `.pptx` + `.md` summary of the analyses (no subfolders) |
| `upstream_workflows/` | (optional) Separate pipelines for raw data preprocessing |

### Repo files

| Path | Role |
|------|------|
| `templates/` | The exact tree and starter files that generated projects receive |
| `scripts/*.sh` | Bash tools to initialize/create/add a project or analysis |
| `CLAUDE.md` (root of each project) | Claude Code guidance: where each artifact goes + which `.md` docs to generate |
| `.gitignore` | Keeps large sequencing data & run outputs out of version control |
| `LICENSE` | MIT license terms |
| `RELEASING.md` | How releases are cut (release-please) |

---
