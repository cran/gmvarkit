% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/uncondMoments.R
\name{get_regime_autocovs}
\alias{get_regime_autocovs}
\title{Calculate regimewise autocovariance matrices}
\usage{
get_regime_autocovs(gmvar)
}
\arguments{
\item{gmvar}{an object of class \code{'gmvar'} created with \code{fitGMVAR} or \code{GMVAR}.}
}
\value{
Returns an \eqn{(d x d x p+1 x M)} array containing the first p regimewise autocovariance matrices.
  The subset \code{[, , j, m]} contains the j-1:th lag autocovariance matrix of the m:th regime.
}
\description{
\code{get_regime_autocovs} calculates the first p regimewise autocovariance
 matrices \eqn{\Gamma_{m}(j)} for the given GMVAR model.
}
\examples{
# GMVAR(1,2), d=2 model:
params122 <- c(0.623, -0.129, 0.959, 0.089, -0.006, 1.006, 1.746,
 0.804, 5.804, 3.245, 7.913, 0.952, -0.037, -0.019, 0.943, 6.926,
 3.982, 12.135, 0.789)
mod122 <- GMVAR(p=1, M=2, d=2, params=params122)
get_regime_autocovs(mod122)

# GMVAR(2,2), d=2 model with AR-parameters restricted to be
# the same for both regimes:
C_mat <- rbind(diag(2*2^2), diag(2*2^2))
params222c <- c(1.031, 2.356, 1.786, 3.000, 1.250, 0.060, 0.036,
 1.335, -0.290, -0.083, -0.047, -0.356, 0.934, -0.152, 5.201, 5.883,
 3.560, 9.799, 0.368)
mod222c <- GMVAR(p=2, M=2, d=2, params=params222c, constraints=C_mat)
get_regime_autocovs(mod222c)

# Structural GMVAR(2, 2), d=2 model identified with sign-constraints:
params222s <- c(1.03, 2.36, 1.79, 3, 1.25, 0.06, 0.04, 1.34, -0.29,
 -0.08, -0.05, -0.36, 1.2, 0.05, 0.05, 1.3, -0.3, -0.1, -0.05, -0.4,
  0.89, 0.72, -0.37, 2.16, 7.16, 1.3, 0.37)
W_222 <- matrix(c(1, NA, -1, 1), nrow=2, byrow=FALSE)
mod222s <- GMVAR(p=2, M=2, d=2, params=params222s, structural_pars=list(W=W_222))
get_regime_autocovs(mod222s)
}
\references{
\itemize{
   \item Kalliovirta L., Meitz M. and Saikkonen P. 2016. Gaussian mixture vector autoregression.
           \emph{Journal of Econometrics}, \strong{192}, 485-498.
   \item Lütkepohl H. 2005. New Introduction to Multiple Time Series Analysis,
           \emph{Springer}.
   \item Virolainen S. 2020. Structural Gaussian mixture vector autoregressive model. Unpublished working
     paper, available as arXiv:2007.04713.
 }
}
\seealso{
Other moment functions: 
\code{\link{cond_moments}()},
\code{\link{get_regime_means}()},
\code{\link{uncond_moments}()}
}
\concept{moment functions}