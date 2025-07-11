#!/bin/bash

# Usage: ./add_topic_to_project.sh 01 Topic2

# Input arguments
project_code=$1
topic_name=$2

if [ -z "$project_code" ] || [ -z "$topic_name" ]; then
    echo "Usage: $0 <project_code> <topic_name>"
    exit 1
fi

# Define base path for topic
base_path=04-analysis/Analysis_${project_code}/Ana/${topic_name}

# Create topic structure with timestamped run folder
mkdir -p ${base_path}/$(date +%F)_run/{figures,results,logs}
touch ${base_path}/$(date +%F)_run/params.json
touch ${base_path}/$(date +%F)_run/summary.txt
touch ${base_path}/analysis.log

echo "✅ New topic '${topic_name}' added to project ${project_code}."

