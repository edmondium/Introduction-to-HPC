#!/bin/bash

#SBATCH -J ARRAY
#SBATCH -A DD-23-116
#SBATCH -p qcpu
#SBATCH -o array-%j.out
#SBATCH -N 1
#SBATCH -t 1
#SBATCH --array 0,1,5-10
#SBATCH --reservation=dd-23-116_2024-06-04T10:00:00_2024-06-04T12:30:00_5_qcpu

source ./modules.sh

echo $SLURM_JOB_ID: $SLURM_ARRAY_JOB_ID-$SLURM_ARRAY_TASK_ID

