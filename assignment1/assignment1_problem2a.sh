#!/bin/bash

#SBATCH --job-name=assignment1_p2a
#SBATCH --output=assignment1_problem2a.out
#SBATCH --error=assignment1_problem2a.err
#SBATCH --time=00:05:00

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

apptainer exec assignment1.sif bash -c '
echo "Kernel version: $(uname -r)"
echo "Python 3 version: $(python3 --version | awk "{print \$2}")"
echo "CPU model: $(grep -m 1 "model name" /proc/cpuinfo | cut -d ":" -f2 | xargs)"
'
