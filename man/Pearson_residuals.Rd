% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/loglikelihood.R
\name{Pearson_residuals}
\alias{Pearson_residuals}
\title{Calculate multivariate Pearson residuals of a GMVAR, StMVAR, or G-StMVAR model}
\usage{
Pearson_residuals(gsmvar, standardize = TRUE)
}
\arguments{
\item{gsmvar}{an object of class \code{'gsmvar'}, typically created with \code{fitGSMVAR} or \code{GSMVAR}.}

\item{standardize}{Should the residuals be standardized? Use \code{FALSE} to obtain raw residuals.}
}
\value{
Returns \eqn{((n_obs-p) x d)} matrix containing the residuals,
  \eqn{j}:th column corresponds to the time series in the \eqn{j}:th column of the data.
}
\description{
\code{Pearson_residuals} calculates multivariate Pearson residuals for a GMVAR, StMVAR, or G-StMVAR model.
}
\examples{
# GMVAR(1,2), d=2 model:
params12 <- c(0.55, 0.112, 0.344, 0.055, -0.009, 0.718, 0.319, 0.005, 0.03,
 0.619, 0.173, 0.255, 0.017, -0.136, 0.858, 1.185, -0.012, 0.136, 0.674)
mod12 <- GSMVAR(gdpdef, p=1, M=2, params=params12)
Pearson_residuals(mod12, standardize=FALSE) # Raw residuals
Pearson_residuals(mod12, standardize=TRUE) # Standardized to identity cov.matrix.

# Structural GMVAR(2, 2), d=2 model identified with sign-constraints:
params22s <- c(0.36, 0.121, 0.484, 0.072, 0.223, 0.059, -0.151, 0.395,
 0.406, -0.005, 0.083, 0.299, 0.218, 0.02, -0.119, 0.722, 0.093, 0.032,
 0.044, 0.191, 0.057, 0.172, -0.46, 0.016, 3.518, 5.154, 0.58)
W_22 <- matrix(c(1, 1, -1, 1), nrow=2, byrow=FALSE)
mod22s <- GSMVAR(gdpdef, p=2, M=2, params=params22s, structural_pars=list(W=W_22))
Pearson_residuals(mod22s, standardize=FALSE) # Raw residuals
Pearson_residuals(mod22s, standardize=TRUE) # Standardized to identity cov.matrix.
}
\references{
\itemize{
   \item Kalliovirta L., Meitz M. and Saikkonen P. 2016. Gaussian mixture vector autoregression.
         \emph{Journal of Econometrics}, \strong{192}, 485-498.
   \item Kalliovirta L. and Saikkonen P. 2010. Reliable Residuals for Multivariate Nonlinear
         Time Series Models. \emph{Unpublished Revision of HECER Discussion Paper No. 247}.
   \item Virolainen S. (forthcoming). A statistically identified structural vector autoregression with endogenously
          switching volatility regime. \emph{Journal of Business & Economic Statistics}.
   \item Virolainen S. 2022. Gaussian and Student's t mixture vector autoregressive model with application to the
     asymmetric effects of monetary policy shocks in the Euro area. Unpublished working
     paper, available as arXiv:2109.13648.
 }
}
\seealso{
\code{\link{fitGSMVAR}}, \code{\link{GSMVAR}}, \code{\link{quantile_residuals}},
  \code{\link{diagnostic_plot}}
}
