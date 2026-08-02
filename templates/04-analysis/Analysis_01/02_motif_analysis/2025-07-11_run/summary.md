# Motif Enrichment Analysis

- **Run date:** 2025-07-15
- **Performed by:** <your name>
- **Analysis:** `02_motif_analysis`

## Objective
Identify transcription-factor motifs enriched in the promoters of the DEGs from
`01_diff_expression`, using HOMER.

## Key Settings
- Tool: HOMER `findMotifsGenome.pl`
- Region: ±500 bp around TSS
- Background: matched-GC promoters
- Motif database: HOMER v5.0 (known + de novo)

## Output Files
- Known motifs: `results/homerResults/knownResults.html`
- De novo motifs: `results/homerResults/homerResults.html`
- Motif–DEG links: `results/motif_deg_links.tsv`

## Notes
Inputs derive from `01_diff_expression`; rerun if the DEG list changes.
