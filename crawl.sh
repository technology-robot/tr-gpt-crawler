#!/bin/bash

set -ex

output_json="${2/.csv/.json}"
export CRAWLEE_STORAGE_DIR="$(mktemp -d)" 

echo "Write to $CRAWLEE_STORAGE_DIR ..."

npm run start:cli -- -c $1 -o $output_json
python3 src/convert_to_csv.py $output_json $2
