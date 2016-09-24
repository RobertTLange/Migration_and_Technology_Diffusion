#!/bin/bash

# Download the original data  file and from Erik Hornung's paper from 2014
# Rename the file for further analysis
# Afterwards decompress the folder

wget https://www.aeaweb.org/aer/data/jan2014/20111335_data.zip

mv   raw_data.tar.gz

tar xf 20111335_data.zip

mv AER-2011-1355-data raw_data

# Call R script that computes different imputation methods

Rscript 01_BAT_RL_2016_Imputation.R

# Call R script that computes several IV simulations and the relative bias first introduced by Baeker et. al

#Rscript 03_BAT_RL_2016_Simulation IV.R

 
