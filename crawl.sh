#!/bin/bash

set -ex

echo "Starting Task $CLOUD_RUN_TASK_INDEX , Attempt $CLOUD_RUN_TASK_ATTEMPT ..."

echo "Config: $1 \nGCS Output: $2"

temp_output_dir="$(mktemp -d)"
temp_output_csv="$temp_output_dir/$(basename -- $2)"

output_json="${temp_output_csv/.csv/.json}"
export CRAWLEE_STORAGE_DIR="$(mktemp -d)" 

echo "Write to $CRAWLEE_STORAGE_DIR ..."

# npm run start:cli -- 
node dist/src/cli.js -c $1 -o $output_json

python3 src/convert_to_csv.py $output_json $temp_output_csv

python3 src/copy_gcs.py \
    --input_folder "$temp_output_dir" \
    --output_folder "$(dirname -- $2)"
