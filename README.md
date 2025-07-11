
# 🧬 Bioinformatics Project Directory Structure

This document outlines the structure and best practices for managing complex, multi-step bioinformatics analyses involving different sequencing data types and multiple sub-analyses.

---

## 📌 Key Concepts

- **Project Code (e.g., `01`)**: Shared by all main folders in a given project. Each folder beginning with the same number belongs to the same project (e.g., `01-documentation`, `02-scripts`, etc.).
- **Topic#**: A sub-analysis or logical unit of downstream analysis within a project (e.g., clustering, differential expression, motif discovery).
- **Run Folders**: Timestamped subfolders for each independent analysis run under a topic.

---

## 🗂️ Full Directory Layout Overview

```
project_root/
├── 01-documentation/
├── 02-scripts/
├── 03-data/
├── 04-analysis/
├── 05-reports/
└── upstream_workflows/
```

---

## 📁 01-documentation/ — Metadata, Logs & Sample Info

> Stores key metadata and contextual info for the entire project.

### Contents:
- `Metadata_summary.txt`: High-level index of all project datasets and purposes.
- `Metadata_<project>.txt`: Detailed info for each dataset.
- `sample_sheet.tsv`: Sample-to-condition mapping for each run.
- `data_sources.txt`: Download URLs, versions, checksums for external data.
- `tools_versions.txt` or `tools_env.yaml`: Conda or software versions.
- `experiment_log.txt`: Manual notes on important steps, decisions.
- `README.txt`: Explains the documentation folder.
- `design_diagrams/`: (Optional) pipeline/data flow figures.

---

## 📁 02-scripts/ — Scripts Per Project

> All scripts (R, Python, shell) related to analyses in this project.

### Structure:
```
02-scripts/
└── Script_<project_code>/
    ├── script_summary.txt
    ├── pipeline.R
    ├── motif_plot.py
```

**Best Practices:**
- Write what each script does in `script_summary.txt`.
- Keep function-specific scripts separate.
- Use relative paths in scripts for portability.

---

## 📁 03-data/ — Input Data (Raw, Processed, References)

> Contains all data used for downstream analysis, organized per project.

### Structure:
```
03-data/
└── Data_<project_code>/
    ├── Raw/              # Upstream outputs: counts, BAMs, peaks
    ├── Processed/        # Cleaned objects (AnnData, Seurat, tsv)
    └── Reference_Data/   # Genomes, GTFs, motifs, DBs
```

### Notes:
- Never alter files in `Raw/`.
- Use symbolic links or config files in analysis to access them.
- Track sources in `01-documentation/data_sources.txt`.

---

## 📁 04-analysis/ — Results, Figures, Parameters

> All downstream analysis organized by project, then by topic and run.

### Structure:
```
04-analysis/
└── Analysis_<project_code>/
    ├── Ana/
    │   └── TopicX/
    │       ├── YYYY-MM-DD_run/
    │       │   ├── figures/
    │       │   ├── results/
    │       │   ├── logs/
    │       │   ├── params.json
    │       │   └── summary.txt
    │       └── analysis.log
    └── QC/
```

### Best Practices:
- Each `run/` folder contains a self-contained analysis with logs and outputs.
- Use `summary.txt` to describe:
  - Input data (paths)
  - Parameters
  - Scripts used
  - Key findings
- Place all figures in `figures/` and tables in `results/`.

---

## 📁 05-reports/ — Presentations & Communication

> For external-facing slides, posters, final figures.

### Structure:
```
05-reports/
└── Analysis_<project_code>/
    ├── summary.pptx
    ├── final_figures/
    └── poster_draft.pdf
```

### Notes:
- This folder is for presentations only — no raw or intermediate data.
- Final figures should be copied from `04-analysis/.../figures/`.

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
| Start new analysis run | `scripts/new_analysis_run.sh` |
| Export upstream data to data folder | `scripts/export_counts_to_project.sh` |
| Log tool versions | `conda list > tools_versions.txt` |
| Track project-wide metadata | Append to `Metadata_summary.txt` |
| Backup to cloud | `rclone sync` (exclude intermediate files) |

---

## ✅ Folder Role Summary

| Folder                     | Role |
|---------------------------|------|
| `01-documentation/`       | Metadata, logs, source tracking, versioning |
| `02-scripts/`             | Reproducible scripts per project |
| `03-data/`                | All raw, processed, and reference input data |
| `04-analysis/`            | Topic-based results and summaries |
| `05-reports/`             | Slides, final visualizations |
| `upstream_workflows/`     | Separate, clean pipelines for raw data preprocessing |

---

