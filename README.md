# The Impact of Skilled-Worker Immigration on the Diffusion of New Technologies
# Author: Robert Tjarko Lange

This repository provides the results/findings from my bachelor thesis composed under the supervision of Prof. Susanne Prantl at the University of Cologne. The thesis is based on the QJE paper of Erik Hornung "Immigration and the diffusion of technology: The Huguenot diaspora in Prussia" (2014). I highlight several theoretical short-comings (endogeneity of the instrument, cluster-bootstrap standard errors) of the estimation strategy as well as problems arising from the exploitation of the unique historical data set (robustness of the treatment effect under different imputation methods).

If you are interested in replicating my findings please start by downloading the original from the American Economic Association using the following link: https://www.aeaweb.org/articles?id=10.1257/aer.104.1.84

I would have loved to automate the complete pipeline by downloading the data set from the command line. Unfortunately, AEA does not allow an SSL connection to the data set. Therefore, this step has to be executed manually. 

The repository contains both code and my final thesis. The code consists out of four files:

master.sh - pipeline file for automated execution
01_BAT_RL_2016_Imputation.R - computes missing values for the ln input variable using different methods
02_BAT_RL_2016_Replication.do - replication and extending computations using the imputed variables
03_BAT_RL_2016_Simulation IV.R - basic instrumental variables estimator simulations and display of relative bias.

Please save the compressed data file and all code files in one folder and execute the master.sh file from the shell (bash master.sh). Before that make sure that you have a version of stata and R installed. The output should consist of three log-files which display the output of the computations. 

Please feel free to contact me if you have any ideas/considerations how I can enhance the analysis.

Barcelona, September 2016
Robert T Lange
Barcelona Graduate School of Economics