% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/backwardCompatibility.R
\name{gmvar_to_sgmvar}
\alias{gmvar_to_sgmvar}
\title{DEPRECATED! USE THE FUNCTION fitGSMVAR INSTEAD!
Switch from two-regime reduced form GMVAR model to a structural model.}
\usage{
gmvar_to_sgmvar(gmvar, calc_std_errors = TRUE)
}
\arguments{
\item{gmvar}{object of class 'gmvar'}

\item{calc_std_errors}{should approximate standard errors be calculated?}
}
\value{
Returns an object of class \code{'gsmvar'} defining a structural GMVAR, StMVAR, or G-StMVAR model based on a
  two-regime reduced form GMVAR, StMVAR, or G-StMVAR model, with the main diagonal of the B-matrix normalized to be
  positive.
}
\description{
DEPRECATED! USE THE FUNCTION fitGSMVAR INSTEAD!
\code{gsmvar_to_sgsmvar} constructs SGMVAR model based on a reduced
  form GMVAR, StMVAR, or G-StMVAR model.
}
\details{
The switch is made by simultaneously diagonalizing the two error term covariance matrices
  with a well known matrix decomposition (Muirhead, 1982, Theorem A9.9) and then normalizing the
  diagonal of the matrix W positive (which implies positive diagonal of the B-matrix). Models with
  more that two regimes are not supported because the matrix decomposition does not generally
  exists for more than two covariance matrices. If the model has only one regime (= regular SVAR model),
  a symmetric and pos. def. square root matrix of the error term covariance matrix is used \strong{unless}
  \code{cholesky = TRUE} is set in the arguments, in which case Cholesky identification is employed.

  In order to employ a structural model with Cholesky identification and multiple regimes (\code{M > 1}),
  use the function \code{GIRF} directly with a reduced form model (see \code{?GIRF}).

  The columns of \eqn{W} as well as the lambda parameters can be re-ordered (without changing the implied
  reduced form model) afterwards with the function \code{reorder_W_columns}. Also all signs in any column
  of \eqn{W} can be swapped (without changing the implied reduced form model) afterwards with the function
  \code{swap_W_signs}. These two functions work with models containing any number of regimes.
}
\references{
\itemize{
   \item Muirhead R.J. 1982. Aspects of Multivariate Statistical Theory, \emph{Wiley}.
   \item Kalliovirta L., Meitz M. and Saikkonen P. 2016. Gaussian mixture vector autoregression.
         \emph{Journal of Econometrics}, \strong{192}, 485-498.
   \item Virolainen S. (forthcoming). A statistically identified structural vector autoregression with endogenously
          switching volatility regime. \emph{Journal of Business & Economic Statistics}.
   \item Virolainen S. 2022. Gaussian and Student's t mixture vector autoregressive model with application to the
     asymmetric effects of monetary policy shocks in the Euro area. Unpublished working
     paper, available as arXiv:2109.13648.
 }
}
\seealso{
\code{\link{gsmvar_to_sgsmvar}}
}
