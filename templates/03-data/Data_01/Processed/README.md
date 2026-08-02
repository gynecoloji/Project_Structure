# Data_<project_code>/Processed/

Processed data derived from raw files — used as **input for downstream analysis**
(differential expression, clustering, network construction, …).

## Processed Files

| File Name | Description | Method Used | Date |
|-----------|-------------|-------------|------|
| counts_filtered.tsv | Filtered raw counts (genes > 10 counts) | featureCounts + filtering | 2025-07-11 |
| norm_counts_log2.tsv | Log2-normalized counts (CPM or DESeq2 norm) | DESeq2 | 2025-07-11 |
| batch_corrected_counts.tsv | Batch-corrected expression matrix | ComBat (sva) | 2025-07-12 |
| gene_metadata.tsv | Gene annotation table | GENCODE v44 | 2025-07-11 |
| sample_metadata.tsv | Sample annotations | Manual / sample sheet | 2025-07-11 |

## Preprocessing Workflow

1. **Filtering** — remove lowly expressed genes (<10 counts in ≥2 samples).
2. **Normalization** — log2 via DESeq2 variance-stabilizing transformation.
3. **Batch correction** — ComBat for a known batch variable (e.g. sequencing date).
4. **Metadata curation** — sample/gene metadata from GENCODE and the sample sheet.

## Data Provenance

- Raw input: `../Raw/*.tsv`
- Script used: `../../02-scripts/Script_<project_code>/01_preprocess_counts.R`
- Versions: R 4.3.2 · DESeq2 1.40.1 · sva/ComBat 3.48.0

## Notes

- Keep sample and gene IDs consistent across all files.
- Back up key processed files before rerunning preprocessing.
- Use log2-normalized data for PCA/heatmaps; use raw or VST for DEGs.

_Last updated: 2025-07-11_
