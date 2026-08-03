#!/bin/bash
#
# Usage:   ./add_project_to_existing.sh <project_code> <description> [output_dir] [analysis_name]
# Example: ./scripts/add_project_to_existing.sh 02 "Bulk ATAC-seq tumor vs normal" ~/projects/my_study
#
# Adds a new project code to an EXISTING structure (created by
# create_project_structure.sh). The project-wide documentation files are left
# untouched; only the per-project folders for <project_code> are added. The
# first analysis is 01_<analysis_name> (default: 01_analysis1).

set -euo pipefail

project_code="${1:-}"
description="${2:-}"
output_dir="${3:-.}"
analysis_name="${4:-analysis1}"

if [ -z "$project_code" ] || [ -z "$description" ]; then
    echo "Usage: $0 <project_code> <description> [output_dir] [analysis_name]"
    exit 1
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
template_dir="$(cd "$script_dir/.." && pwd)/templates"

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

# ── 01 Documentation (only the per-project metadata) ──────────────────
mkdir -p 01-documentation
echo "${description}" > "01-documentation/Metadata_${project_code}.md"
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
sed -i "s#01_diff_expression#${analysis_dir}#g" "$run_dir/params.json" "$run_dir/summary.md" \
        "04-analysis/Analysis_${project_code}/overview.md"
: > "04-analysis/Analysis_${project_code}/${analysis_dir}/analysis.log"

# ── 05 Reports (project-level summary; .pptx + .md only, no subfolders) ─
install_file "05-reports/Analysis_02/report_summary.md" "05-reports/Analysis_${project_code}/report_summary.md"
sed -i "s#01_diff_expression#${analysis_dir}#g" "05-reports/Analysis_${project_code}/report_summary.md"

echo "✅ New project ${project_code} added under ${output_dir}."
echo "   First analysis: 04-analysis/Analysis_${project_code}/${analysis_dir}/ (run: ${run_date}_run)"
