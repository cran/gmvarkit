% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/GMVARconstruction.R
\name{swap_parametrization}
\alias{swap_parametrization}
\title{Swap the parametrization of a GMVAR model}
\usage{
swap_parametrization(gmvar)
}
\arguments{
\item{gmvar}{an object of class \code{'gmvar'} created with \code{fitGMVAR} or \code{GMVAR}.}
}
\value{
Returns an object of class \code{'gmvar'} defining the specified reduced form or structural GMVAR model.
  Can be used to work with other functions provided in \code{gmvarkit}.

  Remark that the first autocovariance/correlation matrix in \code{$uncond_moments} is for the lag zero,
  the second one for the lag one, etc.
}
\description{
\code{swap_parametrization} swaps the parametrization of a GMVAR model
 to \code{"mean"} if the current parametrization is \code{"intercept"}, and vice versa.
}
\details{
\code{swap_parametrization} is a convenient tool if you have estimated the model in
 "intercept"-parametrization, but wish to work with "mean"-parametrization in the future, or vice versa.
 In \code{gmvarkit}, the approximate standard errors are only available for parametrized parameters.
}
\examples{
\donttest{
# These examples use the data 'eurusd' which comes with the
# package, but in a scaled form.
data <- cbind(10*eurusd[,1], 100*eurusd[,2])
colnames(data) <- colnames(eurusd)

# GMVAR(2,2), d=2 model:
params222 <- c(-11.904, 154.684, 1.314, 0.145, 0.094, 1.292, -0.389,
 -0.070, -0.109, -0.281, 0.920, -0.025, 4.839, 11.633, 124.983, 1.248,
  0.077, -0.040, 1.266, -0.272, -0.074, 0.034, -0.313, 5.855, 3.570,
  9.838, 0.740)
mod222 <- GMVAR(data, p=2, M=2, params=params222, parametrization="mean")
mod222 # mean parametrization

mod222_2 <- swap_parametrization(mod222)
mod222_2 # intercept parametrization

# Structural GMVAR(2, 2), d=2 model identified with sign-constraints:
params222s <- c(1.03, 2.36, 1.79, 3, 1.25, 0.06, 0.04, 1.34, -0.29,
 -0.08, -0.05, -0.36, 1.2, 0.05, 0.05, 1.3, -0.3, -0.1, -0.05, -0.4,
  0.89, 0.72, -0.37, 2.16, 7.16, 1.3, 0.37)
W_222 <- matrix(c(1, 1, -1, 1), nrow=2, byrow=FALSE)
mod222s <- GMVAR(data, p=2, M=2, params=params222s, parametrizatio="intercept",
 structural_pars=list(W=W_222))
mod222s # intercept parametrization

mod222s_2 <- swap_parametrization(mod222s)
mod222s_2 # mean parametrization
}
}
\references{
\itemize{
   \item Kalliovirta L., Meitz M. and Saikkonen P. 2016. Gaussian mixture vector autoregression.
         \emph{Journal of Econometrics}, \strong{192}, 485-498.
   \item Kalliovirta L. and Saikkonen P. 2010. Reliable Residuals for Multivariate Nonlinear
         Time Series Models. \emph{Unpublished Revision of HECER Discussion Paper No. 247}.
   \item Virolainen S. 2020. Structural Gaussian mixture vector autoregressive model. Unpublished working
     paper, available as arXiv:2007.04713.
 }
}
\seealso{
\code{\link{fitGMVAR}}, \code{\link{GMVAR}}, \code{\link{iterate_more}}, \code{\link{update_numtols}}
}
