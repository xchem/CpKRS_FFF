#!/bin/bash

mkdir -p retrosynthesis

/opt/xchem-fragalysis-2/maxwin/conda/bin/syndirella run --input CpKRS_FrAncestor_bulkdock_iter1_cluster_best5_syndirella_input.csv --output retrosynthesis --just_retro

/opt/xchem-fragalysis-2/maxwin/conda/bin/syndirella run --input CpKRS_FrAncestor_bulkdock_iter2_cluster_best5_syndirella_input.csv --output retrosynthesis --just_retro

# sbatch --job-name "CpKRS_syndirella" --mem 16000 $HOME2/slurm/run_bash_with_conda.sh retro.sh