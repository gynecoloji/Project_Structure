
# 🧬 Bioinformatics Project Directory Structure

This document outlines the structure and best practices for managing complex, multi-step bioinformatics analyses involving different sequencing data types and multiple sub-analyses.

---

## 📌 Key Concepts

- **Project Code (e.g., `01`)**: Shared by all main folders for a given project. Each folder for the same project ends in the same number (`Script_01`, `Data_01`, `Analysis_01`).
- **Analysis number (`01_`, `02_`, …)**: Each downstream analysis gets a two-digit number and a short name (e.g. `01_diff_expression`). The **same number is reused** for that analysis across `02-scripts/`, `04-analysis/`, and `05-reports/`, so a script, its results, and its report line up.
- **Run Folders**: Timestamped subfolders (`YYYY-MM-DD_run`) for each independent run of an analysis.

> All shared documentation lives in `.md` files so it renders nicely on GitHub; tabular data stays as `.tsv`, parameters as `.json`, and run logs as `.log`.

---

## 🗂️ Full Directory Layout Overview

```
project_root/
├── CLAUDE.md             # Claude Code guidance: where outputs go + which .md docs to write
├── 01-documentation/
├── 02-scripts/
├── 03-data/
├── 04-analysis/
├── 05-reports/
└── upstream_workflows/   # optional, created manually
```

---

## 📁 01-documentation/ — Metadata, Logs & Sample Info

> Stores key metadata and contextual info for the entire project.

### Contents:
- `Metadata_summary.md`: High-level index of all project datasets and purposes.
- `Metadata_<project>.md`: Detailed info for each dataset.
- `sample_sheet.tsv`: Sample-to-condition mapping for each run.
- `data_sources.md`: Download URLs, versions, checksums for external data.
- `tools_versions.md`: Human-readable table of tools & versions.
- `environment.yml`: Conda environment spec — recreate with `conda env create -f 01-documentation/environment.yml`.
- `experiment_log.md`: Manual notes on important steps, decisions.
- `README.md`: Explains the documentation folder.
- `design_diagrams/`: (Optional) pipeline/data flow figures.

---

## 📁 02-scripts/ — Scripts Per Project

> All scripts (R, Python, shell) related to analyses in this project.

### Structure:
```
02-scripts/
└── Script_<project_code>/
    ├── script_summary.md
    ├── 01_preprocess_counts.R   # analysis 01_<name>
    ├── 01_run_deseq2.R          # analysis 01_<name>
    └── 02_motif_analysis.sh     # analysis 02_<name>
```

**Best Practices:**
- Prefix each script with its analysis number so it lines up with `04-analysis/` and `05-reports/`. Several scripts can share a number if they feed the same analysis.
- Describe every script in `script_summary.md`.
- Keep function-specific scripts separate and use relative paths for portability.

---

## 📁 03-data/ — Input Data (Raw, Processed, References)

> Contains all data used for downstream analysis, organized per project.

### Structure:
```
03-data/
└── Data_<project_code>/
    ├── Raw/              # Upstream outputs: counts, BAMs, peaks
    ├── Processed/        # Cleaned objects (AnnData, Seurat, tsv) + README.md
    └── Reference_Data/   # Genomes, GTFs, motifs, DBs
```

### Notes:
- Never alter files in `Raw/`.
- Use symbolic links or config files in analysis to access them.
- Track sources in `01-documentation/data_sources.md`.
- Large data (`Raw/`, `Reference_Data/`, BAMs, FASTQs, `.rds`, …) is kept out of git by `.gitignore`.

---

## 📁 04-analysis/ — Results, Figures, Parameters

> All downstream analysis organized by project, then by numbered analysis and run.

### Structure:
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

### Best Practices:
- Each numbered analysis (`01_<name>`, `02_<name>`, …) matches a script prefix in `02-scripts/` and a report folder in `05-reports/`.
- Each `run/` folder is a self-contained run with its own logs and outputs.
- Use `summary.md` to describe input data (paths), parameters, scripts used, and key findings.
- Place figures in `figures/` and tables in `results/`.

---

## 📁 05-reports/ — Presentations & Communication

> For external-facing slides, posters, and final figures — organized by the same analysis numbers.

### Structure:
```
05-reports/
└── Analysis_<project_code>/
    ├── 01_<name>/           # final figures / slides for analysis 01
    └── 02_<name>/           # final figures / slides for analysis 02
```

### Notes:
- This folder is for presentations only — no raw or intermediate data.
- Final figures should be copied from `04-analysis/.../<NN>_<name>/.../figures/`.

---

## 📁 upstream_workflows/ — Pipelines for Raw Data Processing

> Each subfolder corresponds to a data type with its own workflow.

### Structure (mostly depending on upstream workflow):
```
upstream_workflows/
├── scRNAseq/
├── bulkRNAseq/
├── bulkATACseq/
├── bulkChIPseq/
├── bulkCutAndRun/
└── shared_references/
```

### Notes:
- ⚠️ This folder is **optional and is not created by the setup scripts** — add it manually if your workflow needs a separate raw-data-processing stage.
- Final outputs (e.g., count matrices) are transferred to `03-data/Data_<project_code>/Raw/`.
- Use symbolic links or export scripts to automate transfer.
- `shared_references/` contains indexed genomes, motifs, GTFs, etc., used across pipelines.

---

## 🔄 Workflow Flowchart

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

## 🧰 Optional Tools & Automation Suggestions

| Task | Tool/Script |
|------|-------------|
| Initialize a new project structure | `scripts/create_project_structure.sh <code> "<desc>" [dir] [analysis_name]` |
| Add another project code | `scripts/add_project_to_existing.sh <code> "<desc>" [dir] [analysis_name]` |
| Add a new numbered analysis (auto 02, 03, …) | `scripts/add_analysis_to_project.sh <code> <name> [dir]` |
| Log tool versions | `conda list > 01-documentation/tools_versions.md` |
| Recreate the conda environment | `conda env create -f 01-documentation/environment.yml` |
| Track project-wide metadata | Auto-appended to `Metadata_summary.md` by the scripts |
| Backup to cloud | `rclone sync` (exclude intermediate files) |

---

## ✅ Folder Role Summary

| Folder                     | Role |
|---------------------------|------|
| `01-documentation/`       | Metadata, logs, source tracking, versioning |
| `02-scripts/`             | Reproducible, number-prefixed scripts per project |
| `03-data/`                | All raw, processed, and reference input data |
| `04-analysis/`            | Numbered analyses, runs, results and summaries |
| `05-reports/`             | Slides, final visualizations (same analysis numbers) |
| `upstream_workflows/`     | (optional) Separate, clean pipelines for raw data preprocessing |

## Appendix

| Folder               | File                 | Role |
|----------------------|----------------------|------|
| templates/ | |templates for the above directory tree and files included in it |
| scripts/ | *.sh |bash files to initialize/create/add a project or analysis |
| (root) | CLAUDE.md | Claude Code guidance: where each artifact goes + which `.md` docs to generate |
| (root) | .gitignore | keeps large sequencing data & run outputs out of version control |
| (root) | LICENSE | MIT license terms |

## Run scripts

The scripts build the project tree in the **current directory** by default, or in
an optional `[output_dir]` passed as the third argument. Starter files are
auto-populated from `templates/` (real headers/examples, not empty files). Point
them at the directory where your project should live — **not** inside this repo —
so you don't scaffold on top of the templates.

```bash
git clone https://github.com/gynecoloji/Project_Structure.git
cd Project_Structure
chmod +x scripts/*.sh

# Initialize a new project (code 01); the optional 4th arg names the first analysis:
./scripts/create_project_structure.sh 01 "Bulk RNA-seq tumor vs normal project" ~/projects/my_study diff_expression

# Add another project code (02) to the same location:
./scripts/add_project_to_existing.sh 02 "Bulk ATAC-seq tumor vs normal project" ~/projects/my_study

# Add a new numbered analysis to project 01 (auto-assigned 02, 03, …):
./scripts/add_analysis_to_project.sh 01 motif_analysis ~/projects/my_study
```

> Omit the trailing path to create the structure in the current directory.
> Re-running with an existing project code is refused so you can't overwrite work;
> `add_analysis_to_project.sh` checks that the project exists and picks the next free number.

---
