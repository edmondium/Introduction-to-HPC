#!/bin/bash

#SBATCH -A DD-23-116
#SBATCH -p qcpu
#SBATCH -J SIMPLE
#SBATCH --reservation=dd-23-116_2024-06-04T10:00:00_2024-06-04T12:30:00_5_qcpu

srun hostname
