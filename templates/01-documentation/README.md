# 📁 01-documentation/

This folder contains **global documentation** shared across all projects in this
workspace. It includes metadata, software versions, and data provenance.

## File Descriptions

- `Metadata_summary.md`: Index of all individual projects and their descriptions.
- `Metadata_<project>.md`: Description of an individual project (e.g. project 01, 02).
- `sample_sheet.tsv`: Sample-to-condition mapping used in analyses (shared or example sheet).
- `data_sources.md`: Links and versioning of all external databases or resources used.
- `tools_versions.md`: Software and tool versions to ensure reproducibility.
- `environment.yml`: Conda environment spec — recreate with `conda env create -f 01-documentation/environment.yml`.
- `experiment_log.md`: Chronological log of major decisions and actions across all projects.
- `design_diagrams/`: Folder for pipeline flowcharts or experimental designs.

_Last updated: 2025-07-11_
