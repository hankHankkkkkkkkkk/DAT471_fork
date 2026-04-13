#!/bin/bash

#SBATCH --job-name=assignment1_p2b
#SBATCH --output=assignment1_problem2b.out
#SBATCH --error=assignment1_problem2b.err
#SBATCH --time=00:05:00

set -euo pipefail

CONTAINER="/data/courses/2026_dat471_dit066/containers/assignment1.sif"
DATASET="/data/courses/2026_dat471_dit066/datasets/bike_sharing_hourly.csv"

apptainer exec --bind /data:/data "$CONTAINER" bash -s <<'INNER_EOF'
set -euo pipefail

dataset="/data/courses/2026_dat471_dit066/datasets/bike_sharing_hourly.csv"

if [[ ! -f "$dataset" ]]; then
  echo "Could not find the bike sharing dataset: $dataset"
  exit 1
fi

echo "Using dataset: $dataset"
echo
echo "Output from /opt/mystery.py:"
python3 /opt/mystery.py "$dataset"
echo
echo "Contents of /opt/mystery.py:"
cat /opt/mystery.py
INNER_EOF
