# Script Summary — Project <project_code>

Scripts for project **<project_code>**. The leading number on each script links it
to the matching analysis folder in `04-analysis/Analysis_<project_code>/<NN>_<name>/`
and the report folder in `05-reports/Analysis_<project_code>/<NN>_<name>/`.

| Script | Analysis (shared #) | Purpose | Inputs | Outputs | Notes |
|--------|---------------------|---------|--------|---------|-------|
| `01_preprocess_counts.R` | `01_diff_expression` | Filter & normalize raw counts | `../../03-data/Data_<project_code>/Raw/*.counts.tsv` | `../../03-data/Data_<project_code>/Processed/norm_counts_log2.tsv` | DESeq2 VST |
| `01_run_deseq2.R` | `01_diff_expression` | Differential expression | `../../03-data/Data_<project_code>/Processed/norm_counts_log2.tsv` | `.../01_diff_expression/<run>/results/deseq2_results.tsv` | BH FDR < 0.05 |
| `02_motif_analysis.sh` | `02_motif_analysis` | Motif discovery (HOMER) | `../../03-data/Data_<project_code>/Processed/peak_calls.bed` | `.../02_motif_analysis/<run>/results/homerResults/` | Requires HOMER |

## Conventions

- **One number per analysis** (`01_`, `02_`, …); a script shares the number of the
  analysis it feeds. Several scripts can share a number if they belong to the same analysis.
- Keep scripts modular; use relative paths for portability.
- Record tool versions in `01-documentation/tools_versions.md` and `environment.yml`.
- Update this table whenever you add or change a script.

_Last updated: 2025-07-11_
