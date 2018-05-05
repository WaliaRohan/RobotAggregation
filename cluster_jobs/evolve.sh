#!/usr/bin/env bash
#SBATCH -N 1
#SBATCH -n 12
#SBATCH -t 12:00:00
#SBATCH -J evolve

# Stop execution after any error
set -e

# Useful variables
MYUSER=$(whoami)
LOCALDIR=/tmp
DATADIR=~/data
PROJDIR=$PWD

# or another folder where you want your data to be stored
# Job-related variables
THISJOB=n_classes

# some way to identify this job execution
WORKDIR=$LOCALDIR/$MYUSER/$THISJOB

# Create work dir from scratch, enter it
rm -rf $WORKDIR && mkdir -p $WORKDIR && cd $WORKDIR

# setup the directories and files we expect
cp -r $PROJDIR/bin .
cp -r $PROJDIR/build .
cp -r $PROJDIR/controllers .
cp -r $PROJDIR/loop_functions .
cp -r $PROJDIR/experiments .
cp -r $PROJDIR/params .
cp $PROJDIR/CMakeLists.txt .
cp $PROJDIR/python/cma_evolve.py .

# Execute program (this also writes files in work dir)
echo $WORKDIR
./cma_eovlve.py -p 12 -t 1 experiments/4_class/*uniform* build/loop_functions/libcluster_metric.so -v -g 100

# Transfer generated files into home directory
cp cma_evolve_output_*.txt $DATADIR

# Cleanup
rm -r $WORKDIR
