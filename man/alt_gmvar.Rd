% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/GMVARconstruction.R
\name{alt_gmvar}
\alias{alt_gmvar}
\title{Construct a GMVAR model based on results from an arbitrary estimation round of \code{fitGMVAR}}
\usage{
alt_gmvar(
  gmvar,
  which_round = 1,
  which_largest,
  calc_cond_moments = TRUE,
  calc_std_errors = TRUE
)
}
\arguments{
\item{gmvar}{an object of class \code{'gmvar'} created with \code{fitGMVAR} or \code{GMVAR}.}

\item{which_round}{based on which estimation round should the model be constructed? An integer value in 1,...,\code{ncalls}.}

\item{which_largest}{based on estimation round with which largest log-likelihood should the model be constructed?
An integer value in 1,...,\code{ncalls}. For example, \code{which_largest=2} would take the second largest log-likelihood
and construct the model based on the corresponding estimates. If used, then \code{which_round} is ignored.}

\item{calc_cond_moments}{should conditional means and covariance matrices should be calculated?
Default is \code{TRUE} if the model contains data and \code{FALSE} otherwise.}

\item{calc_std_errors}{should approximate standard errors be calculated?}
}
\value{
Returns an object of class \code{'gmvar'} defining the specified reduced form or structural GMVAR model.
  Can be used to work with other functions provided in \code{gmvarkit}.

  Remark that the first autocovariance/correlation matrix in \code{$uncond_moments} is for the lag zero,
  the second one for the lag one, etc.
}
\description{
\code{alt_gmvar} constructs a GMVAR model based on results from an arbitrary estimation round of \code{fitGMVAR}.
}
\details{
It's sometimes useful to examine other estimates than the one with the highest log-likelihood. This function
  is wrapper around \code{GMVAR} that picks the correct estimates from an object returned by \code{fitGMVAR}.
}
\examples{
\donttest{
# These are long running examples and use parallel computing
# Running the below examples takes approximately 20 seconds.

data(eurusd, package="gmvarkit")
data <- cbind(10*eurusd[,1], 100*eurusd[,2])
colnames(data) <- colnames(eurusd)

# GMVAR(1,2) model
fit12 <- fitGMVAR(data, p=1, M=2, ncalls=2, seeds=7:8)
fit12
fit12_2 <- alt_gmvar(fit12, which_largest=2)
fit12_2
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
