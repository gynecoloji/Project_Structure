# CLAUDE.md

Guidance for Claude Code when working in this bioinformatics project. The project
is organized by **project code** and, within each project, by **numbered
analyses**.

Notation: `<code>` is a project code (`01`, `02`, …); `NN_<name>` is a numbered
analysis (`01_diff_expression`, `02_motif_analysis`, …).

## Same project = same code

Everything that ends in the same project code refers to the **same project**.
For project `01`, all of these belong together:

- `01-documentation/Metadata_01.md`  (its description/metadata)
- `02-scripts/Script_01/`            (its scripts)
- `03-data/Data_01/`                 (its data)
- `04-analysis/Analysis_01/`         (its analyses)
- `05-reports/Analysis_01/`          (its report summary)

When you create or edit files for a project, keep them all under that one code.

## Where to save things

| Artifact | Location |
|----------|----------|
| Scripts (R / Python / shell) | `02-scripts/Script_<code>/NN_<name>.<ext>` — prefix with the analysis number it feeds |
| Raw data (never modify) | `03-data/Data_<code>/Raw/` |
| Processed data | `03-data/Data_<code>/Processed/` |
| Reference genomes / GTFs / DBs | `03-data/Data_<code>/Reference_Data/` |
| Analysis run outputs | `04-analysis/Analysis_<code>/NN_<name>/YYYY-MM-DD_run/` → `figures/`, `results/`, `logs/` |
| Run parameters | `04-analysis/Analysis_<code>/NN_<name>/YYYY-MM-DD_run/params.json` |
| QC outputs | `04-analysis/Analysis_<code>/QC/` |
| **Report summary** | `05-reports/Analysis_<code>/` — a `.pptx` deck and a `.md` only, **no subfolders** |
| Metadata & documentation | `01-documentation/` (see below) |

**Matched-number rule (within a project):** an analysis `NN_<name>` in
`04-analysis` reuses the same `NN_<name>` for its script prefix in `02-scripts`.
Several scripts can share a number if they feed the same analysis. **Reports are
per-project summaries, not per-analysis — see below.**

**Create structure with the scripts, not `mkdir` by hand** — they build the
matched folders and drop in starter files:
- New analysis (auto-numbered): `scripts/add_analysis_to_project.sh <code> <name>`
- New project code: `scripts/add_project_to_existing.sh <code> "<description>"`

## Always generate the Markdown docs (in the matched folder)

Whenever you produce an artifact, also write or update its Markdown documentation,
under the **same project code**, before treating the task as done:

- **Scripts** → add a row to `02-scripts/Script_<code>/script_summary.md`
  (script name, analysis #, purpose, inputs, outputs).
- **Processed data** → update `03-data/Data_<code>/Processed/README.md`
  (per file: description, method, provenance, tool versions).
- **Analysis results** → write `.../NN_<name>/YYYY-MM-DD_run/summary.md`
  (objective, key settings, output files, findings) and `params.json` (all
  parameters); add the analysis to `04-analysis/Analysis_<code>/overview.md` and
  append a line to `.../NN_<name>/analysis.log`.
- **Reports** → maintain the project's summary in `05-reports/Analysis_<code>/`:
  a `.pptx` deck and `report_summary.md` that **summarize the results from
  `04-analysis/Analysis_<code>/`**. Generate **only these `.pptx` and `.md`
  files — do NOT create subfolders** in `05-reports/Analysis_<code>/`.

Everything (except the `.pptx`) is Markdown (`.md`) with real Markdown tables. Use
relative paths and ISO dates (`YYYY-MM-DD`).

## Keeping docs in sync (doc-writer agent)

This project ships a **`doc-writer`** subagent (`.claude/agents/doc-writer.md`).
Whenever you add or change a script, produce analysis outputs, or land processed
data, **delegate to `doc-writer`** — or run the **`/sync-docs`** command — to
generate/update the matched Markdown docs automatically. It is non-destructive
(fills gaps, preserves your edits) and safe to run repeatedly.

A `PostToolUse` hook (`.claude/settings.json` → `.claude/hooks/doc-reminder.sh`)
reminds you to do this **automatically** whenever a script (`02-scripts/`),
processed-data file (`03-data/*/Processed/`), or analysis output (`04-analysis/`)
is written — so docs never silently fall behind.

## Always keep 01-documentation/ current

Update the relevant metadata file whenever the project changes:

- `Metadata_summary.md` — one line per project code (the index).
- `Metadata_<code>.md` — description of that project.
- `sample_sheet.tsv` — sample → condition / replicate / file mapping.
- `data_sources.md` — every external download: source, URL, version, date accessed.
- `tools_versions.md` + `environment.yml` — tools and pinned versions (keep in sync).
- `experiment_log.md` — chronological log of major steps and decisions.

## Conventions

- Treat `Raw/` and `Reference_Data/` as read-only inputs.
- Large data (BAM / FASTQ / counts / `.rds` / …) is gitignored — record provenance
  in `data_sources.md`; do not commit the data itself.
- Prefer relative paths in scripts for portability.
