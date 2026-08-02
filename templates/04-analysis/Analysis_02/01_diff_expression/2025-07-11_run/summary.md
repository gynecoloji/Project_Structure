# Differential Expression Analysis

- **Run date:** 2025-07-11
- **Performed by:** <your name>
- **Analysis:** `01_diff_expression`

## Objective
Identify differentially expressed genes between treated and control samples using DESeq2.

## Key Settings
- Normalization: median-of-ratios
- Filtering: genes with ≥10 counts in at least 2 samples
- P-adjust method: Benjamini–Hochberg
- FDR cutoff: 0.05

## Output Files
- DEG list: `results/deseq2_results.tsv`
- Volcano plot: `figures/volcano_plot.pdf`
- PCA plot: `figures/pca_plot.pdf`

## Notes
Rerun needed if filtering or contrast groups change.
