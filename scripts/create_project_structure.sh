#!/bin/bash
#
# Usage:   ./create_project_structure.sh <project_code> <description> [output_dir] [analysis_name]
# Example: ./scripts/create_project_structure.sh 01 "Bulk RNA-seq tumor vs normal" ~/projects/my_study
#
# Initializes a fresh bioinformatics project scaffold. The tree is created in
# [output_dir] (default: the current directory). The first analysis folder is
# named 01_<analysis_name> (default: 01_analysis1) and the SAME number is used
# for its scripts (02-scripts) and its report folder (05-reports). Starter files
# are populated from templates/ (real headers/examples, not empty files).

set -euo pipefail

project_code="${1:-}"
description="${2:-}"
output_dir="${3:-.}"
analysis_name="${4:-analysis1}"

if [ -z "$project_code" ] || [ -z "$description" ]; then
    echo "Usage: $0 <project_code> <description> [output_dir] [analysis_name]"
    exit 1
fi

# Resolve the templates/ directory relative to this script (absolute path,
# computed before we cd into the output directory).
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
template_dir="$(cd "$script_dir/.." && pwd)/templates"

# install_file <template-relative-path> <destination>
# Copies a template into place, substituting the project code into the example
# placeholders. Falls back to an empty file (with a warning) if the template is
# missing, so the script still works outside the repo.
install_file() {
    local rel="$1" dest="$2"
    mkdir -p "$(dirname "$dest")"
    if [ -f "$template_dir/$rel" ]; then
        sed -e "s/<project_code>/${project_code}/g" \
            -e "s/Data_01/Data_${project_code}/g" \
            -e "s/Analysis_01/Analysis_${project_code}/g" \
            -e "s/Script_01/Script_${project_code}/g" \
            "$template_dir/$rel" > "$dest"
    else
        echo "⚠️  template not found: $rel (creating empty $dest)" >&2
        : > "$dest"
    fi
}

# install_once <template-relative-path> <destination>
# Like install_file, but never overwrites an existing file. Used for the
# project-wide documentation (env spec, tool versions, sample sheet, …) so
# re-running the script to add another project code can't clobber your edits.
install_once() {
    local rel="$1" dest="$2"
    if [ -e "$dest" ]; then
        echo "↩︎  keeping existing $dest"
        return 0
    fi
    install_file "$rel" "$dest"
}

# keep <dir> — mark an otherwise-empty directory so it survives in git.
keep() { mkdir -p "$1"; : > "$1/.gitkeep"; }

mkdir -p "$output_dir"
cd "$output_dir"

# Guard against clobbering an existing project code.
if [ -d "04-analysis/Analysis_${project_code}" ]; then
    echo "❌ Project code ${project_code} already exists in ${output_dir}." >&2
    echo "   Use add_analysis_to_project.sh to extend it, or pick a different code." >&2
    exit 1
fi

run_date="$(date +%F)"
analysis_dir="01_${analysis_name}"
run_dir="04-analysis/Analysis_${project_code}/${analysis_dir}/${run_date}_run"

# ── Project root (Claude Code guidance + doc-writer agent) ───────────
install_once "CLAUDE.md" "CLAUDE.md"
install_once ".claude/agents/doc-writer.md"  ".claude/agents/doc-writer.md"
install_once ".claude/commands/sync-docs.md" ".claude/commands/sync-docs.md"
install_once ".claude/settings.json"         ".claude/settings.json"
install_once ".claude/hooks/doc-reminder.sh" ".claude/hooks/doc-reminder.sh"

# ── 01 Documentation (project-wide; created once) ─────────────────────
mkdir -p 01-documentation/design_diagrams
keep 01-documentation/design_diagrams
install_once "01-documentation/README.md"           01-documentation/README.md
install_once "01-documentation/sample_sheet.tsv"    01-documentation/sample_sheet.tsv
install_once "01-documentation/data_sources.md"     01-documentation/data_sources.md
install_once "01-documentation/tools_versions.md"   01-documentation/tools_versions.md
install_once "01-documentation/environment.yml"     01-documentation/environment.yml
install_once "01-documentation/experiment_log.md"   01-documentation/experiment_log.md
echo "${description}" > "01-documentation/Metadata_${project_code}.md"

# Append to the summary index only if this project code is not already listed.
if ! grep -q "^Metadata_${project_code}:" 01-documentation/Metadata_summary.md 2>/dev/null; then
    echo "Metadata_${project_code}: ${description}" >> 01-documentation/Metadata_summary.md
fi

# ── 02 Scripts ────────────────────────────────────────────────────────
install_file "02-scripts/Script_01/script_summary.md" "02-scripts/Script_${project_code}/script_summary.md"

# ── 03 Data ───────────────────────────────────────────────────────────
keep "03-data/Data_${project_code}/Raw"
keep "03-data/Data_${project_code}/Reference_Data"
install_file "03-data/Data_01/Processed/README.md" "03-data/Data_${project_code}/Processed/README.md"

# ── 04 Analysis ───────────────────────────────────────────────────────
keep "04-analysis/Analysis_${project_code}/QC"
install_file "04-analysis/Analysis_02/overview.md" "04-analysis/Analysis_${project_code}/overview.md"
mkdir -p "$run_dir"
keep "$run_dir/figures"; keep "$run_dir/results"; keep "$run_dir/logs"
install_file "04-analysis/Analysis_01/01_diff_expression/2025-07-11_run/params.json" "$run_dir/params.json"
install_file "04-analysis/Analysis_01/01_diff_expression/2025-07-11_run/summary.md"  "$run_dir/summary.md"
# Retarget the example analysis name to the folder we just created.
sed -i "s#01_diff_expression#${analysis_dir}#g" "$run_dir/params.json" "$run_dir/summary.md" \
        "04-analysis/Analysis_${project_code}/overview.md"
: > "04-analysis/Analysis_${project_code}/${analysis_dir}/analysis.log"

# ── 05 Reports (project-level summary; .pptx + .md only, no subfolders) ─
install_file "05-reports/Analysis_02/report_summary.md" "05-reports/Analysis_${project_code}/report_summary.md"
sed -i "s#01_diff_expression#${analysis_dir}#g" "05-reports/Analysis_${project_code}/report_summary.md"

echo "✅ Project code ${project_code} created under ${output_dir}."
echo "   First analysis: 04-analysis/Analysis_${project_code}/${analysis_dir}/ (run: ${run_date}_run)"
echo "   Add scripts as 02-scripts/Script_${project_code}/01_*.<ext> to keep the shared number."
