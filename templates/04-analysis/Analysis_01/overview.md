# Analysis_<project_code> — Overview

## Objective
Integrative analysis of bulk RNA-seq and transcription-factor motif data to
uncover regulatory drivers of differential expression under treatment.

## Data Summary
- Sample size: 6 (3 control, 3 treatment)
- Data types: bulk RNA-seq counts (featureCounts), motif peaks (HOMER), reference hg38
- Data sources: see `01-documentation/data_sources.md`

## Tools & Pipelines
- Bulk RNA-seq: STAR + featureCounts → DESeq2 (R)
- Motif analysis: HOMER
- Visualization: ggplot2, EnhancedVolcano, ComplexHeatmap

## Analyses
Each analysis has its own numbered folder here; the **same number** is reused for
its scripts in `02-scripts/Script_<project_code>/` and its report folder in
`05-reports/Analysis_<project_code>/`.

| # | Folder | Focus | Last Run | Notes |
|---|--------|-------|----------|-------|
| 01 | `01_diff_expression` | DEGs treated vs control | 2025-07-11 | DESeq2 + volcano plot |
| 02 | `02_motif_analysis` | TF motif enrichment in DEG promoters | 2025-07-15 | HOMER motifs linked to DEGs |

## Key Findings
- 356 DEGs (FDR < 0.05), 148 upregulated in treatment
- Enrichment of AP-1 family motifs (Fos, Jun) in upregulated promoters
- Several DEGs (FOSB, JUNB) have upstream motifs enriched in CRISPR screen hits

## Next Steps
- [ ] Validate network in public datasets
- [ ] Add ligand–receptor inference layer
- [ ] Prepare final figures for paper draft

_Last updated: 2025-07-11_
