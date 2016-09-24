########################################################################
#Robert Lange
#Bachelor Thesis: The Impact of Skilled-Worker Immigration on the Diffusion of New Technologies
#Examination No.: 33252
#Comparison of OLS and IV estimator using Monte Carlo (MC) simulations
########################################################################
set.seed(100) #replication: sets seed for random number/variable generation
########################################################################

beta_0 <- 0.5
beta_1 <- 1
beta_2 <- 0.3

if(!require(MASS)) install.packages("MASS", dependencies=TRUE)

library(MASS) #needed for multivariate normal distribution simulation

##------------------------------------------
#OLS MC SIMULATION
##------------------------------------------

OLS<- function(Y, X){
##Function computes the OLS beta-estimates
##Inputs: Design matrix X and Dependent variable Y
##Output: Vector of OLS Estimate of beta coefficients   
  beta_hat <- c(solve(t(X)%*%X) %*% t(X) %*% Y)
}

MCSimulation_OLS <- function(n, t) {
##Function simulates Data generation process and OLS estimation in one step  
##Inputs: Sample size n and Number of Iterations k
##Outputs: Vector of estimates for beta_1 for each iteration
  beta_1_hat<- c()
  for (j in 1:t){
    
    x_i<-rnorm(n)
    epsilon<-rnorm(n)
    Y<- beta_0 + beta_1*x_i + epsilon
    
    intercept    <- rep(1, n)
    X<- cbind(intercept, x_i)
    
    beta_hat <- OLS(Y,X)
    beta_1_hat[[j]] <- beta_hat[2]
  }  
  return(beta_1_hat)
}

beta_1_hat_n_20<-MCSimulation_OLS(n=20,t=10000)
beta_1_hat_n_100<-MCSimulation_OLS(n=100,t=10000)
beta_1_hat_n_1000<-MCSimulation_OLS(n=1000,t=10000)

##------------------------------------------
#OLS MC SIMULATION WITH OMITTED VARIABLE
##------------------------------------------

MCSimulation_OVB <- function(n, t){
##Function simulates Data generation process and OLS estimation in one step for the case of one omitted variable  
##Inputs: Sample size n and Number of Iterations k
##Outputs: Vector of estimates for beta_1 (OVB) for each iteration
  beta_1_hat_OVB <- c()
  
  for (j in 1:t){
    intercept <- rep(1, n)
    x<-mvrnorm(n, mu=c(0,0), Sigma=matrix(c(1,0.5,0.5,1), ncol=2))
    epsilon <- rnorm(n)
    Y <- beta_0 + beta_1*x[,1] + beta_2*x[,2] + epsilon
    X<- cbind(intercept, x[,1])
    beta_hat_OVB <- OLS(Y=Y,X=X)
    beta_1_hat_OVB[[j]] <- beta_hat_OVB[2]
  }
  return(beta_1_hat_OVB)
}

beta_1_hat_OVB_n_20<-MCSimulation_OVB(n=20,t=10000)
beta_1_hat_OVB_n_100<-MCSimulation_OVB(n=100,t=10000)
beta_1_hat_OVB_n_1000<-MCSimulation_OVB(n=1000,t=10000)

##------------------------------------------
#IV MC SIMULATION WITH EXOGENOUS INSTRUMENT
##------------------------------------------

MCSimulation_IV <- function(n,t){
##Function simulates Data generation process and OLS estimation in one step for the case of one omitted variable and one instrument 
##Inputs: Sample size n and Number of Iterations k
##Outputs: Vector of estimates for beta_1 (IV) for each iteration
  beta_1_hat_IV <- c()  
  
  for (j in 1:t){
    intercept <- rep(1, n)
    x<-mvrnorm(n, mu=c(0,0,0), Sigma=matrix(c(1,0.5,0.3,0.5,1,0,0.3,0,1), ncol=3))
    epsilon <- rnorm(n)
    Y <- beta_0 + beta_1*x[,1] + beta_2*x[,2] + epsilon

    X<-x[,1]
    z<-x[,3]
    beta_hat_IV <- solve(t(z)%*%X)%*%t(z)%*%Y
    
    beta_1_hat_IV[[j]] <- beta_hat_IV
  }
  return(beta_1_hat_IV)
}

beta_1_hat_IV_n_20<-MCSimulation_IV(n=20,t=10000)
beta_1_hat_IV_n_100<-MCSimulation_IV(n=100,t=10000)
beta_1_hat_IV_n_1000<-MCSimulation_IV(n=1000,t=10000)


##------------------------------------------
#IV MC SIMULATION WITH ENDOGENOUS INSTRUMENT
##------------------------------------------

MCSimulation_IVw <- function(n,t){
  ##Function simulates Data generation process and OLS estimation in one step for the case of one omitted variable and one endogenous instrument 
  ##Intrument is endogenous due to correlation (0.4) with the omitted variable
  ##Inputs: Sample size n and Number of Iterations k
  ##Outputs: Vector of estimates for beta_1 (IV) for each iteration
  beta_1_hat_IVw <- c()  
  
  for (j in 1:t){
    intercept <- rep(1, n)
    x<-mvrnorm(n, mu=c(0,0,0), Sigma=matrix(c(1,0.5,0.3,0.5,1,0.4,0.3,0.4,1), ncol=3))
    epsilon <- rnorm(n)
    Y <- beta_0 + beta_1*x[,1] + beta_2*x[,2] + epsilon
    
    X<-x[,1]
    z<-x[,3]
    beta_hat_IVw <- solve(t(z)%*%X)%*%t(z)%*%Y
    
    beta_1_hat_IVw[[j]] <- beta_hat_IVw
  }
  return(beta_1_hat_IVw)
}

beta_1_hat_IVw_n_20<-MCSimulation_IVw(n=20,t=10000)
beta_1_hat_IVw_n_100<-MCSimulation_IVw(n=100,t=10000)
beta_1_hat_IVw_n_1000<-MCSimulation_IVw(n=1000,t=10000)

##----------------------
#Numerical Comparison of Estimators: Bias, Variance and Mean Squared Error (MSE) 
##----------------------
results <- function(beta_20, beta_100, beta_1000){
  c("Bias Estimate for n=20"=(1/10000)*sum(beta_20-beta_1),
    "Bias Estimate for n=100"=(1/10000)*sum(beta_100-beta_1),
    "Bias Estimate for n=1000"=(1/10000)*sum(beta_1000-beta_1),
    "Mean Squared Error for n=20"=(1/10000)*(beta_20-beta_1)%*%(beta_20-beta_1),
    "Mean Squared Error for n=100"=(1/10000)*(beta_100-beta_1)%*%(beta_100-beta_1),
    "Mean Squared Error for n=1000"=(1/10000)*(beta_1000-beta_1)%*%(beta_1000-beta_1),
    "Variance for n=20"=(1/10000)*(beta_20-mean(beta_20))%*%(beta_20-mean(beta_20)),
    "Variance for n=100"=(1/10000)*(beta_100-mean(beta_100))%*%(beta_100-mean(beta_100)),
    "Variance for n=1000"=(1/10000)*(beta_1000-mean(beta_1000))%*%(beta_1000-mean(beta_1000))) 
}

results_OLS <- results(beta_20=beta_1_hat_n_20, beta_100=beta_1_hat_n_100, beta_1000=beta_1_hat_n_1000)
results_OVB <- results(beta_20=beta_1_hat_OVB_n_20, beta_100=beta_1_hat_OVB_n_100, beta_1000=beta_1_hat_OVB_n_1000)
results_IV <- results(beta_20=beta_1_hat_IV_n_20 , beta_100=beta_1_hat_IV_n_100 , beta_1000=beta_1_hat_IV_n_1000 )
results_IVw <- results(beta_20=beta_1_hat_IVw_n_20 , beta_100=beta_1_hat_IVw_n_100 , beta_1000=beta_1_hat_IVw_n_1000 )

results_Overall <- cbind(results_OLS, results_OVB, results_IV, results_IVw)
results_Overall

##----------------------
#Graphical Comparison of Estimators: Densities
##----------------------
par(mfrow=c(2,2)) 
colors <- c("red", "blue", "black")
labels <- c("n=20", "n=100", "n=1000")

plot(density(beta_1_hat_n_1000), xlim=c(0,2),main="a) OLS Estimator Density", ylab="", xlab="Value of Estimator",pch=8, col="black")
lines(density(beta_1_hat_n_20), col="red")
lines(density(beta_1_hat_n_100), col="blue")
legend("topleft", inset=.03, title="Sample Sizes",
labels, lwd=1, lty=c(1, 1, 1), col=colors, cex=0.5)
abline(v=1, col="navyblue")

plot(density(beta_1_hat_OVB_n_1000), xlim=c(0,2), main="b) OVB Estimator Density", ylab="", xlab="Value of Estimator",pch=8, col="black")
lines(density(beta_1_hat_OVB_n_20), col="red")
lines(density(beta_1_hat_OVB_n_100), col="blue")
legend("topleft", inset=.03, title="Sample Sizes",
labels, lwd=1, lty=c(1, 1, 1), col=colors, cex=0.5)
abline(v=1, col="navyblue")

plot(density(beta_1_hat_IV_n_1000), xlim=c(0,2), main="c) IV Estimator Density with Exogenous Instrument", ylab="", xlab="Value of Estimator",pch=8, col="black")
lines(density(beta_1_hat_IV_n_20), col="red")
lines(density(beta_1_hat_IV_n_100), col="blue")
legend("topleft", inset=.03, title="Sample Sizes",
labels, lwd=1, lty=c(1, 1, 1), col=colors, cex=0.5)
abline(v=1, col="navyblue")

plot(density(beta_1_hat_IVw_n_1000), xlim=c(0,2),main="d) IV Estimator Density with Endogenous Instrument", ylab="", xlab="Value of Estimator",pch=8, col="black")
lines(density(beta_1_hat_IVw_n_20), col="red")
lines(density(beta_1_hat_IVw_n_100), col="blue")
legend("topleft", inset=.03, title="Sample Sizes",
labels, lwd=1, lty=c(1, 1, 1), col=colors, cex=0.5)
abline(v=1, col="navyblue")

