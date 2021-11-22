### R code from vignette source 'gmvarkit-vignette.Rnw'

###################################################
### code chunk number 1: preliminaries
###################################################
options(prompt = "R> ", continue = "+  ", width = 70, useFancyQuotes = FALSE)
library(gmvarkit)


###################################################
### code chunk number 2: data
###################################################
data("gdpdef", package = "gmvarkit")
fit12t <- fitGSMVAR(gdpdef, p=1, M=2, model="StMVAR", ncalls=2, seeds=1:2)


###################################################
### code chunk number 3: alt_gsmvar
###################################################
fit12t_alt <- alt_gsmvar(fit12t, which_largest=2)


###################################################
### code chunk number 4: print
###################################################
print(fit12t_alt)


###################################################
### code chunk number 5: stmvar_to_gstmvar
###################################################
fit12gs <- stmvar_to_gstmvar(fit12t_alt, maxdf=100)


###################################################
### code chunk number 6: stmvar_to_gstmvar
###################################################
summary(fit12gs)


###################################################
### code chunk number 7: print_std_errors
###################################################
print_std_errors(fit12gs)


###################################################
### code chunk number 8: plotseries
###################################################
plot(fit12gs, type="series")


###################################################
### code chunk number 9: plotdensity
###################################################
plot(fit12gs, type="density")


###################################################
### code chunk number 10: get_foc
###################################################
get_foc(fit12gs)


###################################################
### code chunk number 11: get_foc
###################################################
get_soc(fit12gs)


###################################################
### code chunk number 12: profilelogliks
###################################################
profile_logliks(fit12gs, scale=0.02, precision=50)


###################################################
### code chunk number 13: gsmvar_sgsmvar
###################################################
fit12gss <- gsmvar_to_sgsmvar(fit12gs)
fit12gss


###################################################
### code chunk number 14: constraint_ex1
###################################################
p <- 1 # Any autoregressive order
d <- 2 # Whatever the dimension of the time series is
I_pd2 <- diag(p*d^2) # The appropriate diagonal matrix
(C1 <- rbind(I_pd2, I_pd2)) # Stack them on top of each other


###################################################
### code chunk number 15: constraint_ex2
###################################################
c_tilde <- matrix(0, nrow=2*2^2, ncol=4)
c_tilde[c(1, 12, 21, 32)] <- 1
c_tilde
C2 <- rbind(c_tilde, c_tilde)


###################################################
### code chunk number 16: gsmvar_ex1
###################################################
params112 <- c(0, 1, 0.2, 0.2, 0.2, -0.2, 1, 0.1, 1, 3)
mod112 <- GSMVAR(p=1, M=1, d=2, params=params112, model="StMVAR")
mod112


###################################################
### code chunk number 17: predict
###################################################
mypred <- predict(fit12gs, n_ahead=10, nsim=100, pred_type="mean",
                  pi_type="two-sided", pi=c(0.95, 0.90),
                  mix_weights=TRUE)


