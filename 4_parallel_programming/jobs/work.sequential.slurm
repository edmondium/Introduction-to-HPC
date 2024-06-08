#!/bin/bash

#SBATCH -J SEQ
#SBATCH -A DD-23-116
#SBATCH -p qcpu
#SBATCH -o sequential-%j.out
#SBATCH -N 1
#SBATCH -t 10:00
#SBATCH --reservation=dd-23-116_2024-06-04T10:00:00_2024-06-04T12:30:00_5_qcpu

source ./modules.sh

srun ./build/work
srun ./build/work
