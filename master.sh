#!/bin/bash

#The Impact of Skilled-Worker Immigration on the Diffusion of New Technologies
#Author: Robert Tjarko Lange

# Download the original data  file and from Erik Hornung's paper from 2014
# wget https://www.aeaweb.org/aer/data/jan2014/20111335_data.zip


# Rename the file for further analysis
# Afterwards decompress the folder

tar xf 20111335_data.zip

mv AER-2011-1355-data raw_data

cd raw_data
mv * ../
cd ..
rmdir raw_data


# Call R script that computes different imputation methods

Rscript 01_BAT_RL_2016_Imputation.R > log_imputation.txt

# Call Stata in batch mode

stata < 02_BAT_RL_2016_Replication.do  >log_reg_bootstrap.log &

# Call R script that computes several IV simulations and the relative bias first introduced by Baeker et. al

Rscript 03_BAT_RL_2016_Simulation IV.R > log_iv_simulation.txt

echo computing job finished



