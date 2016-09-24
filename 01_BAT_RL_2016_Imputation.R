########################################################################
#Robert Lange
#Bachelor Thesis: The Impact of Skilled-Worker Immigration on the Diffusion of New Technologies
#Examination No.: 33252
#Missing Data Imputation for Ln Input 1802 - Alternatives to Multiple Imputation used by Hornung (2014)
#Main Source: Gelman and Hill (2006) - Chapter 25: Missing-data imputation
########################################################################
set.seed(42) #replication: sets seed for random number/variable generation
########################################################################
#If packages are missing install the necessary ones - install.package("name-of-package")

if(!require(foreign)) install.packages("foreign", dependencies=TRUE)
if(!require(mice)) install.packages("mice", dependencies=TRUE)
if(!require(VIM)) install.packages("VIM", dependencies=TRUE)
if(!require(arm)) install.packages("arm", dependencies=TRUE)
if(!require(pastecs)) install.packages("pastecs", dependencies=TRUE)

library(foreign)
library(mice)
library(VIM)
library(arm)
library(pastecs)

########################################################################

#Data Set-Up
Hornung_textiles <- read.dta(file=„…/raw_data/hornung-data-textiles.dta")
Hornung_nontextiles <- read.dta(file=„…/rawdata/hornung-data-nontextiles.dta")

n <- length(Hornung_textiles$input1802_all)

input_reg_data <- data.frame (cbind (Hornung_textiles$ln_input1802_all, 
                                     Hornung_textiles$wool, Hornung_textiles$linen, Hornung_textiles$cotton, Hornung_textiles$silk, Hornung_textiles$hats, Hornung_textiles$socks, Hornung_textiles$tuch, 
                                     Hornung_textiles$output1802_all, Hornung_textiles$looms1802_all, Hornung_textiles$workers1802_all, Hornung_textiles$vieh1816_schaf_ganz_veredelt_pc))
########################################################################

#Visual Analysis of Missing data
md.pattern(input_reg_data)
aggr_plot <- aggr(input_reg_data, col=c('navyblue','red'), numbers=TRUE, sortVars=TRUE, labels=names(data), 
                 cex.axis=.7, gap=3, ylab=c("Histogram of missing data","Pattern"))

########################################################################
#Mean Imputation - Gelman and Hill (2006), p.532
########################################################################


mean.imp <- function (a){
#Function performs mean imputation. The variable that has to be imputed is taken as input.
#The missing values are filled by the mean value of the input variable. The variance is decreased. 
#Problem - leaves mean unchanged but decreases variance 
  missing <- is.na(a) #Logic - true/false that missing
  n.missing <- sum(missing) #Number of Missings in data
  a.obs <- a[!missing] #Only non-missing values
  imputed <- a
  imputed[missing] <- mean(a.obs, replace=TRUE) #sample - randomly assigns an existing value to a missing obs.
  return (imputed)
}

mean_imp_ln_input1802 <- mean.imp(Hornung_textiles$ln_input1802_all)

########################################################################
#Random Imputation - Gelman and Hill (2006), p.534
########################################################################

random.imp <- function (a){
#Function performs random imputation. The variable that has to be imputed is taken as input.
#The missing values are filled by a randomly sampled value of a non-missing observation.  
  missing <- is.na(a) #Logic - true/false that missing
  n.missing <- sum(missing) #Number of Missings in data
  a.obs <- a[!missing] #Only non-missing values
  imputed <- a
  imputed[missing] <- sample (a.obs, n.missing, replace=TRUE) #sample - randomly assigns an existing value to a missing obs.
  return (imputed)
}

random_imp_ln_input1802 <- random.imp(Hornung_textiles$ln_input1802_all)

########################################################################
#Regression Predictions - Gelman and Hill (2006), p.535
########################################################################

#Different Specifications are possible. Including specific industry dummies introduces problem of multicollinearity
lm.imp_input <- lm (Hornung_textiles$ln_input1802_all ~ Hornung_textiles$wool + Hornung_textiles$linen + Hornung_textiles$cotton + Hornung_textiles$silk + Hornung_textiles$hats + Hornung_textiles$socks + Hornung_textiles$tuch + 
                      Hornung_textiles$output1802_all + Hornung_textiles$looms1802_all + Hornung_textiles$workers1802_all + Hornung_textiles$vieh1816_schaf_ganz_veredelt_pc,
                data=Hornung_textiles, subset=Hornung_textiles$input1802_all>0, na.action = na.exclude)

pred_input <- predict (lm.imp_input, Hornung_textiles)
#Cannot predict values for 53 observations because regressor values are also missing!

impute <- function(a, a.impute){ 
#Function replaces missing value with predicted value.
  ifelse (is.na(a), a.impute, a)
}

reg_imp_ln_input1802 <- impute(Hornung_textiles$ln_input1802_all, pred_input)

########################################################################
#Random Regression Imputation - Gelman and Hill (2006), p.536
########################################################################

pred.2_input <- rnorm(n , predict(lm.imp_input, Hornung_textiles), sigma.hat(lm.imp_input))

reg_random_imp_ln_input1802<- impute(Hornung_textiles$ln_input1802_all, pred.2_input)

########################################################################
#Iterative Regression Imputation - Gelman and Hill (2006), p.539
########################################################################

random_imp_poploss_keyser <- random.imp(Hornung_textiles$poploss_keyser)

n.sims <- 100
for (s in 1:n.sims){
  lm.1 <- lm (Hornung_textiles$ln_input1802_all ~ random_imp_poploss_keyser + Hornung_textiles$wool + Hornung_textiles$linen + Hornung_textiles$cotton + Hornung_textiles$silk + Hornung_textiles$hats + Hornung_textiles$socks + Hornung_textiles$tuch + 
                Hornung_textiles$output1802_all + Hornung_textiles$looms1802_all + Hornung_textiles$workers1802_all + Hornung_textiles$vieh1816_schaf_ganz_veredelt_pc)
  pred.1 <- rnorm (n, predict(lm.1), sigma.hat(lm.1))
  iterative_imp_ln_input1802 <- impute (Hornung_textiles$ln_input1802_all, pred.1)
  
  lm.2 <- lm (Hornung_textiles$poploss_keyser ~ iterative_imp_ln_input1802 + Hornung_textiles$wool + Hornung_textiles$linen + Hornung_textiles$cotton + Hornung_textiles$silk + Hornung_textiles$hats + Hornung_textiles$socks + Hornung_textiles$tuch + 
                Hornung_textiles$output1802_all + Hornung_textiles$looms1802_all + Hornung_textiles$workers1802_all + Hornung_textiles$vieh1816_schaf_ganz_veredelt_pc)
  pred.2 <- rnorm (n, predict(lm.2), sigma.hat(lm.2))
  iterative_imp_poploss <- impute (Hornung_textiles$poploss_keyser, pred.2)
}

########################################################################
#Graphical Comparison of Imputed Data
########################################################################

#Input Imputation - imputed data seems robust to different methods
par(mfrow=c(2,3)) 
hist(Hornung_textiles$ln_input1802_all, main="a) Original Data", xlab="Ln Input 1802", xlim=c(0,15))
hist(Hornung_textiles$mi_ln_input1802_all, main="b) Imputed Data by Hornung", xlab="Ln Input 1802", xlim=c(0,15))
hist(mean_imp_ln_input1802, main="c) Mean Imputation", xlab="Ln Input 1802", xlim=c(0,15))
hist(random_imp_ln_input1802, main="d) Simple Random Imputation", xlab="Ln Input 1802", xlim=c(0,15))
hist(reg_random_imp_ln_input1802, main="e) Random Regression Imputation", xlab="Ln Input 1802", xlim=c(0,15))
hist(iterative_imp_ln_input1802, main="f) Iterative Regression Imputation", xlab="Ln Input 1802", xlim=c(0,15))

#Descriptive Statistics
stat.desc(Hornung_textiles$ln_input1802_all)
stat.desc(Hornung_textiles$mi_ln_input1802_all)
stat.desc(mean_imp_ln_input1802)
stat.desc(random_imp_ln_input1802)
stat.desc(reg_imp_ln_input1802)
stat.desc(iterative_imp_ln_input1802)
stat.desc(reg_random_imp_ln_input1802)

########################################################################
#Outfiling data for further Stata Analysis
########################################################################
id <- Hornung_textiles$id #has to be renamed for proper merging with Stata
rm(list=ls()[! ls() %in% c("id","mean_imp_ln_input1802","random_imp_ln_input1802", "reg_imp_ln_input1802", "iterative_imp_ln_input1802", "reg_random_imp_ln_input1802")])
data_export_stata <- data.frame(cbind(id, mean_imp_ln_input1802, random_imp_ln_input1802, reg_imp_ln_input1802, iterative_imp_ln_input1802, reg_random_imp_ln_input1802))
write.dta(data_export_stata, „…/hornung-data-textiles_R_imputed.dta")




