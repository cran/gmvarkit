% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/uncondMoments.R
\name{get_Sigmas}
\alias{get_Sigmas}
\title{Calculate the dp-dimensional covariance matrices \eqn{\Sigma_{m,p}} in the mixing weights
 of the GMVAR model.}
\usage{
get_Sigmas(p, M, d, all_A, all_boldA, all_Omega)
}
\arguments{
\item{p}{a positive integer specifying the autoregressive order of the model.}

\item{M}{a positive integer specifying the number of mixture components.}

\item{d}{the number of time series in the system.}

\item{all_A}{4D array containing all coefficient matrices \eqn{A_{m,i}}, obtained from \code{pick_allA}.}

\item{all_boldA}{3D array containing the \eqn{((dp)x(dp))} "bold A" matrices related to each mixture component VAR-process,
obtained from \code{form_boldA}. Will be computed if not given.}

\item{all_Omega}{a \code{[d, d, M]} array containing the covariance matrix Omegas}
}
\value{
Returns a \code{[dp, dp, M]} array containing the dp-dimensional covariance matrices for each regime.
}
\description{
\code{get_Sigmas} calculates the dp-dimensional covariance matrices \eqn{\Sigma_{m,p}}
 in the mixing weights of the GMVAR model so that the algorithm proposed by McElroy (2017) employed
 whenever it reduces the computation time.
}
\details{
Calculates the dp-dimensional covariance matrix using the formula (2.1.39) in Lütkepohl (2005) when
 \code{d*p < 12} and using the algorithm proposed by McElroy (2017) otherwise.

 The code in the implementation of the McElroy's (2017) algorithm (in the function \code{VAR_pcovmat}) is
 adapted from the one provided in the supplementary material of McElroy (2017). Reproduced under GNU General
 Public License, Copyright (2015) Tucker McElroy.
}
\references{
\itemize{
   \item Kalliovirta L., Meitz M. and Saikkonen P. 2016. Gaussian mixture vector autoregression.
           \emph{Journal of Econometrics}, \strong{192}, 485-498.
   \item Lütkepohl H. 2005. New Introduction to Multiple Time Series Analysis,
           \emph{Springer}.
   \item McElroy T. 2017. Computation of vector ARMA autocovariances.
         \emph{Statistics and Probability Letters}, \strong{124}, 92-96.
 }
}
