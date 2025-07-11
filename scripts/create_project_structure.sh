#!/bin/bash

# Usage: ./create_project_structure.sh 01 "Project description here"

# Input arguments
project_code=$1
description=$2

if [ -z "$project_code" ] || [ -z "$description" ]; then
    echo "Usage: $0 <project_code> <description>"
    exit 1
fi

# Documentation (fixed folder name)
mkdir -p 01-documentation/design_diagrams

echo -e "Metadata_${project_code}: ${description}" >> 01-documentation/Metadata_summary.txt
echo "${description}" > 01-documentation/Metadata_${project_code}.txt
touch 01-documentation/sample_sheet.tsv
touch 01-documentation/data_sources.txt
touch 01-documentation/tools_versions.txt
touch 01-documentation/experiment_log.txt
touch 01-documentation/README.txt

# Scripts
mkdir -p 02-scripts/Script_${project_code}
touch 02-scripts/Script_${project_code}/script_summary.txt

# Data
mkdir -p 03-data/Data_${project_code}/{Raw,Processed,Reference_Data}
touch 03-data/Data_${project_code}/Processed/Document.txt

# Analysis
mkdir -p 04-analysis/Analysis_${project_code}/QC
mkdir -p 04-analysis/Analysis_${project_code}/Ana/Topic1/$(date +%F)_run/{figures,results,logs}
touch 04-analysis/Analysis_${project_code}/Ana/Topic1/$(date +%F)_run/params.json
touch 04-analysis/Analysis_${project_code}/Ana/Topic1/$(date +%F)_run/summary.txt
touch 04-analysis/Analysis_${project_code}/Ana/Topic1/analysis.log
touch 04-analysis/Analysis_${project_code}/Ana/Document.txt

# Reports
mkdir -p 05-reports/Analysis_${project_code}/final_figures

echo "✅ Project directory for project code ${project_code} created."
