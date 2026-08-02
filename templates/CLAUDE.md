# CLAUDE.md

Guidance for Claude Code when working in this bioinformatics project. The project
uses a **numbered, matched-folder** layout: every analysis has a two-digit number
and a short name (e.g. `01_diff_expression`) that is reused across scripts,
analysis outputs, and reports so related work always lines up.

Notation: `<code>` is a project code (`01`, `02`, …); `NN_<name>` is a numbered
analysis (`01_diff_expression`, `02_motif_analysis`, …).

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
| Final figures / slides / posters | `05-reports/Analysis_<code>/NN_<name>/` |
| Metadata & documentation | `01-documentation/` (see below) |

**Matched-number rule:** an analysis `NN_<name>` in `04-analysis` MUST reuse the
same `NN_<name>` for its script prefix in `02-scripts` and its report folder in
`05-reports`. Never scatter related work under different numbers.

**Create structure with the scripts, not `mkdir` by hand** — they build the
matched folders and drop in starter files:
- New analysis (auto-numbered): `scripts/add_analysis_to_project.sh <code> <name>`
- New project code: `scripts/add_project_to_existing.sh <code> "<description>"`

## Always generate the Markdown docs (in the matched folder)

Whenever you produce an artifact, also write or update its Markdown documentation,
in the **same numbered folder**, before treating the task as done:

- **Scripts** → add a row to `02-scripts/Script_<code>/script_summary.md`
  (script name, analysis #, purpose, inputs, outputs).
- **Processed data** → update `03-data/Data_<code>/Processed/README.md`
  (per file: description, method, provenance, tool versions).
- **Analysis results** → write `.../NN_<name>/YYYY-MM-DD_run/summary.md`
  (objective, key settings, output files, findings) and `params.json` (all
  parameters); add the analysis to `04-analysis/Analysis_<code>/overview.md` and
  append a line to `.../NN_<name>/analysis.log`.
- **Reports** → write a short `README.md` in
  `05-reports/Analysis_<code>/NN_<name>/` listing the final figures and the runs
  they came from.

Everything is Markdown (`.md`) with real Markdown tables. Use relative paths and
ISO dates (`YYYY-MM-DD`).

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
