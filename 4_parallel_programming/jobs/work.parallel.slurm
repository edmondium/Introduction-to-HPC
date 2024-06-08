#!/bin/bash

#SBATCH -J PARALLEL
#SBATCH -A DD-23-116
#SBATCH -p qcpu
#SBATCH -o parallel-%j.out
#SBATCH -N 2
#SBATCH --reservation=dd-23-116_2024-06-04T10:00:00_2024-06-04T12:30:00_5_qcpu

source ./modules.sh

srun -n 8 -c 18 ./build/parallel

