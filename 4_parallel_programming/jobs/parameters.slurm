#!/bin/bash

#SBATCH -J ENV
#SBATCH -A DD-23-116
#SBATCH -p qcpu
#SBATCH -o env-jobid-%j_stepid-%s_hostname-%N_nid-%3n_task-%t_user-%u_jobname-%x.out
#SBATCH -N 1
#SBATCH -t 1
#SBATCH --reservation=dd-23-116_2024-06-04T10:00:00_2024-06-04T12:30:00_5_qcpu

printenv | grep SLURM

