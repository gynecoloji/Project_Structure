#!/bin/bash
#
# Usage:   ./add_analysis_to_project.sh <project_code> <analysis_name> [output_dir]
# Example: ./scripts/add_analysis_to_project.sh 01 motif_analysis ~/projects/my_study
#
# Adds a new numbered analysis to an existing project code. The next free number
# is assigned automatically (01, 02, 03, …), giving a folder NN_<analysis_name>
# under 04-analysis/ with a dated run folder and starter params.json / summary.md
# from templates/. Reports are a single per-project summary in 05-reports/ (a
# .pptx + .md), so no report folder is created here.

set -euo pipefail

project_code="${1:-}"
analysis_name="${2:-}"
output_dir="${3:-.}"

if [ -z "$project_code" ] || [ -z "$analysis_name" ]; then
    echo "Usage: $0 <project_code> <analysis_name> [output_dir]"
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

cd "$output_dir"

analysis_root="04-analysis/Analysis_${project_code}"

# The project must already exist before an analysis can be added to it.
if [ ! -d "$analysis_root" ]; then
    echo "❌ Project code ${project_code} not found in ${output_dir}." >&2
    echo "   Create it first with create_project_structure.sh (or add_project_to_existing.sh)." >&2
    exit 1
fi

# Assign the next free number by scanning existing NN_* analysis folders.
last="$(find "$analysis_root" -maxdepth 1 -type d -name '[0-9][0-9]_*' -printf '%f\n' 2>/dev/null \
        | sed 's/_.*//' | sort -n | tail -1)"
if [ -z "$last" ]; then
    next=1
else
    next=$((10#$last + 1))
fi
NN="$(printf '%02d' "$next")"
analysis_dir="${NN}_${analysis_name}"

if [ -e "${analysis_root}/${analysis_dir}" ]; then
    echo "❌ ${analysis_root}/${analysis_dir} already exists." >&2
    exit 1
fi

run_date="$(date +%F)"
run_dir="${analysis_root}/${analysis_dir}/${run_date}_run"

mkdir -p "$run_dir"
keep "$run_dir/figures"; keep "$run_dir/results"; keep "$run_dir/logs"
install_file "04-analysis/Analysis_01/01_diff_expression/2025-07-11_run/params.json" "$run_dir/params.json"
install_file "04-analysis/Analysis_01/01_diff_expression/2025-07-11_run/summary.md"  "$run_dir/summary.md"
sed -i "s#01_diff_expression#${analysis_dir}#g" "$run_dir/params.json" "$run_dir/summary.md"
: > "${analysis_root}/${analysis_dir}/analysis.log"

echo "✅ Analysis ${analysis_dir} added to project ${project_code} under ${output_dir} (run: ${run_date}_run)."
echo "   Add its scripts as 02-scripts/Script_${project_code}/${NN}_*.<ext> to keep the shared number."
echo "   Summarize it in 05-reports/Analysis_${project_code}/report_summary.md when ready."
