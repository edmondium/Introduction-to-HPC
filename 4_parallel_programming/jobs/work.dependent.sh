#!/bin/bash

INFO=$(sbatch jobs/work.sequential.slurm)
echo $INFO" -- initial"
ID=${INFO##* }
echo $(sbatch -d afterok:$ID  jobs/work.sequential.slurm)" -- afterok"
echo $(sbatch -d afterany:$ID jobs/work.sequential.slurm)" -- afterany"
echo $(sbatch                 jobs/work.sequential.slurm)" -- independent"
echo $(sbatch -d singleton    jobs/work.sequential.slurm)" -- singleton"
