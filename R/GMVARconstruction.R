#' @title Create object of class 'gmvar' defining a GMVAR model
#'
#' @description \code{GMVAR} creates an S3 object of class \code{'gmvar'} that defines a GMVAR model
#'
#' @inheritParams loglikelihood_int
#' @param data a matrix or class \code{'ts'} object with \code{d>1} columns. Each column is taken to represent
#'  a single times series. \code{NA} values are not supported. Ignore if defining a model without data is desired.
#' @param d number of times series in the system, i.e. \code{ncol(data)}. This can be
#'   used to define GMVAR models without data and can be ignored if \code{data} is provided.
#' @param calc_std_errors should approximate standard errors be calculated? Refers to Theorem 3 in the
#'   cited article.
#' @details If data is provided, then also multivariate quantile residuals (\emph{Kalliovirta and Saikkonen 2010})
#'   are computed and included in the returned object.
#' @return Returns an object of class \code{'gmvar'} defining the specified GMVAR model. Can be used
#'   to work with other functions provided in \code{gmvarkit}.
#' @section S3 methods:
#'   Only the print method is available if data is not provided.
#'   If data is provided, then the \code{predict} method is also available.
#' @seealso \code{\link{fitGMVAR}}, \code{\link{add_data}}, \code{\link{swap_parametrization}}
#' @references
#'  \itemize{
#'    \item Kalliovirta L., Meitz M. and Saikkonen P. 2016. Gaussian mixture vector autoregression.
#'          \emph{Journal of Econometrics}, \strong{192}, 485-498.
#'    \item Kalliovirta L. and Saikkonen P. 2010. Reliable Residuals for Multivariate Nonlinear
#'          Time Series Models. \emph{Unpublished Revision of HECER Discussion Paper No. 247}.
#'  }
#' @examples
#' # These examples use the data 'eurusd' which comes with the
#' # package, but in a scaled form.
#' data <- cbind(10*eurusd[,1], 100*eurusd[,2])
#' colnames(data) <- colnames(eurusd)
#'
#' # GMVAR(1,2), d=2 model:
#' params122 <- c(0.623, -0.129, 0.959, 0.089, -0.006, 1.006, 1.746,
#'  0.804, 5.804, 3.245, 7.913, 0.952, -0.037, -0.019, 0.943, 6.926,
#'  3.982, 12.135, 0.789)
#' mod122 <- GMVAR(data, p=1, M=2, params=params122)
#' mod122
#'
#' # GMVAR(1,2), d=2 model without data
#' mod122_2 <- GMVAR(p=1, M=2, d=2, params=params122)
#' mod122_2
#'
#' # GMVAR(2,2), d=2 model with mean-parametrization:
#' params222 <- c(-11.904, 154.684, 1.314, 0.145, 0.094, 1.292, -0.389,
#'  -0.070, -0.109, -0.281, 0.920, -0.025, 4.839, 11.633, 124.983, 1.248,
#'   0.077, -0.040, 1.266, -0.272, -0.074, 0.034, -0.313, 5.855, 3.570,
#'   9.838, 0.740)
#' mod222 <- GMVAR(data, p=2, M=2, params=params222, parametrization="mean")
#' mod222
#'
#' # GMVAR(2,2), d=2 model with AR-parameters restricted to be
#' # the same for both regimes:
#' C_mat <- rbind(diag(2*2^2), diag(2*2^2))
#' params222c <- c(1.031, 2.356, 1.786, 3.000, 1.250, 0.060, 0.036,
#'  1.335, -0.290, -0.083, -0.047, -0.356, 0.934, -0.152, 5.201, 5.883,
#'  3.560, 9.799, 0.368)
#' mod222c <- GMVAR(data, p=2, M=2, params=params222c, constraints=C_mat)
#' mod222c
#'
#' # GMVAR(2,2), d=2 model with AR-parameters restricted to be
#' # the same for both regimes and the non-diagonal elements of
#' # the coefficient matrices constrained to zero.
#' tmp <- matrix(c(1, rep(0, 10), 1, rep(0, 8), 1, rep(0, 10), 1),
#'  nrow=2*2^2, byrow=FALSE)
#' C_mat2 <- rbind(tmp, tmp)
#' params222c2 <- c(0.355, 3.193, -0.114, 2.829, 1.263, 1.338, -0.292,
#'  -0.362, 5.597, 3.456, 9.622, 0.982, -0.327, 5.236, 0.650)
#' mod222c2 <- GMVAR(data, p=2, M=2, params=params222c2,
#'   constraints=C_mat2)
#' mod222c2
#' @export

GMVAR <- function(data, p, M, d, params, conditional=TRUE, parametrization=c("intercept", "mean"), constraints=NULL, calc_std_errors=FALSE) {
  parametrization <- match.arg(parametrization)
  if(!all_pos_ints(c(p, M))) stop("Arguments p and M must be positive integers")
  if(!parametrization %in% c("intercept", "mean")) stop("Argument parametrization has to be 'intercept' or 'mean'")
  if(missing(data) & missing(d)) stop("data or d must be provided")
  if(missing(data)) {
    data <- NA
  } else {
    data <- check_data(data=data, p=p)
    if(missing(d)) {
      d <- ncol(data)
    } else if(ncol(data) != d) {
      warning("ncol(data) does not equal d. Using d = ncol(data)")
      d <- ncol(data)
    }
  }
  check_constraints(p=p, M=M, d=d, constraints=constraints)
  check_parameters(p=p, M=M, d=d, params=params, constraints=constraints)
  npars <- n_params(p=p, M=M, d=d, constraints=constraints)

  if(anyNA(data)) {
    lok_and_mw <- list(loglik=NA, mw=NA)
    IC <- data.frame(AIC=NA, HQIC=NA, BIC=NA)
    qresiduals <- NA
  } else {
    if(npars >= nrow(data)) stop("There are at least as many parameters in the model than there are observations in the data")
    lok_and_mw <- loglikelihood_int(data=data, p=p, M=M, params=params, conditional=conditional,
                                    parametrization=parametrization, constraints=constraints,
                                    to_return="loglik_and_mw", check_params=FALSE, minval=NA)
    qresiduals <- quantile_residuals_int(data=data, p=p, M=M, params=params, conditional=conditional,
                                         parametrization=parametrization, constraints=constraints)
    obs <- ifelse(conditional, nrow(data) - p, nrow(data))
    IC <- get_IC(loglik=lok_and_mw$loglik, npars=npars, obs=obs)
  }
  if(calc_std_errors == TRUE) {
    if(anyNA(data)) {
      warning("Approximate standard errors can't be calculated")
      std_errors <- rep(NA, npars)
    } else {
      std_errors <- tryCatch(standard_errors(data=data, p=p, M=M, params=params, conditional=conditional, parametrization=parametrization,
                                    constraints=constraints, minval=-(10^(ceiling(log10(nrow(data))) + ncol(data) + 1) - 1)),
                             error=function(e) std_errors=rep(NA, npars))
    }
  } else {
    std_errors <- rep(NA, npars)
  }

  structure(list(data=data,
                 model=list(p=p,
                            M=M,
                            d=d,
                            conditional=conditional,
                            parametrization=parametrization,
                            constraints=constraints),
                 params=params,
                 std_errors=std_errors,
                 mixing_weights=lok_and_mw$mw,
                 quantile_residuals=qresiduals,
                 loglik=structure(lok_and_mw$loglik,
                                  class="logLik",
                                  df=npars),
                 IC=IC,
                 all_estimates=NULL,
                 all_logliks=NULL,
                 which_converged=NULL),
            class="gmvar")
}


#' @title Add data to object of class 'gmvar' defining a GMVAR model
#'
#' @description \code{add_data} adds data to object of class '\code{gmvar}' that defines a GMVAR model based
#'   on the given object. Also calculates mixing weights and quantile residuals accordingly.
#'
#' @inheritParams simulateGMVAR
#' @param data a matrix or class \code{'ts'} object with \code{d>1} columns. Each column is taken to represent
#'  a single times series. \code{NA} values are not supported.
#' @return returns an object of class 'gmvar' defining the specified GMVAR model with the data added to the model.
#'   If the object already contained data, the data will be updated.
#' @seealso \code{\link{fitGMVAR}}, \code{\link{GMVAR}}, \code{\link{iterate_more}}
#' @references
#'  \itemize{
#'    \item Kalliovirta L., Meitz M. and Saikkonen P. 2016. Gaussian mixture vector autoregression.
#'          \emph{Journal of Econometrics}, \strong{192}, 485-498.
#'  }
#' @examples
#' # These examples use the data 'eurusd' which comes with the
#' # package, but in a scaled form.
#' data <- cbind(10*eurusd[,1], 100*eurusd[,2])
#' colnames(data) <- colnames(eurusd)
#'
#' # GMVAR(1,2), d=2 model:
#' params122 <- c(0.623, -0.129, 0.959, 0.089, -0.006, 1.006, 1.746,
#'  0.804, 5.804, 3.245, 7.913, 0.952, -0.037, -0.019, 0.943, 6.926,
#'  3.982, 12.135, 0.789)
#' mod122 <- GMVAR(p=1, M=2, d=2, params=params122)
#' mod122
#'
#' mod122_2 <- add_data(data, mod122)
#' mod122_2
#'
#'
#' # GMVAR(2,2), d=2 model with AR-parameters restricted to be
#' # the same for both regimes:
#' C_mat <- rbind(diag(2*2^2), diag(2*2^2))
#' params222c <- c(1.031, 2.356, 1.786, 3.000, 1.250, 0.060, 0.036,
#'  1.335, -0.290, -0.083, -0.047, -0.356, 0.934, -0.152, 5.201, 5.883,
#'  3.560, 9.799, 0.368)
#' mod222c <- GMVAR(p=2, M=2, d=2, params=params222c, constraints=C_mat)
#' mod222c
#'
#' mod222c_2 <- add_data(data, mod222c)
#' mod222c_2
#' @export

add_data <- function(data, gmvar) {
  check_gmvar(gmvar)
  GMVAR(data=data, p=gmvar$model$p, M=gmvar$model$M, params=gmvar$params, conditional=gmvar$model$conditional,
        parametrization=gmvar$model$parametrization, constraints=gmvar$model$constraints)
}


#' @title Swap the parametrization of object of class 'gmvar' defining a GMVAR model
#'
#' @description \code{swap_parametrization} swaps the parametrization of object of class '\code{gmvar}'
#'  to \code{"mean"} if the currect parametrization is \code{"intercept"}, and vice versa.
#'
#' @inheritParams simulateGMVAR
#' @details \code{swap_parametrization()} is convenient tool if you have estimated the model in
#'  "intercept"-parametrization, but wish to work with "mean"-parametrization in the future, or vice versa.
#'  In \code{gmvarkit}, for example the approximate standard errors are only available for
#'  parametrized parameters.
#' @inherit GMVAR references return
#' @inherit add_data seealso
#' @examples
#' \donttest{
#' # These examples use the data 'eurusd' which comes with the
#' # package, but in a scaled form.
#' data <- cbind(10*eurusd[,1], 100*eurusd[,2])
#' colnames(data) <- colnames(eurusd)
#'
#' # GMVAR(1,2), d=2 model:
#' params122 <- c(0.623, -0.129, 0.959, 0.089, -0.006, 1.006, 1.746,
#'  0.804, 5.804, 3.245, 7.913, 0.952, -0.037, -0.019, 0.943, 6.926,
#'  3.982, 12.135, 0.789)
#' mod122 <- GMVAR(data, p=1, M=2, params=params122)
#' mod122 # intercept-parametrization
#'
#' mod122_2 <- swap_parametrization(mod122)
#' mod122_2 # mean-parametrization
#'
#'
#' # GMVAR(2,2), d=2 model:
#' params222 <- c(-11.904, 154.684, 1.314, 0.145, 0.094, 1.292, -0.389,
#'  -0.070, -0.109, -0.281, 0.920, -0.025, 4.839, 11.633, 124.983, 1.248,
#'   0.077, -0.040, 1.266, -0.272, -0.074, 0.034, -0.313, 5.855, 3.570,
#'   9.838, 0.740)
#' mod222 <- GMVAR(data, p=2, M=2, params=params222, parametrization="mean")
#' mod222 # mean-parametrization
#'
#' mod222_2 <- swap_parametrization(mod222)
#' mod222_2 # intercept-parametrization
#' }
#' @export

swap_parametrization <- function(gmvar) {
  check_gmvar(gmvar)
  change_to <- ifelse(gmvar$model$parametrization == "intercept", "mean", "intercept")
  new_params <- change_parametrization(p=gmvar$model$p, M=gmvar$model$M, d=gmvar$model$d, params=gmvar$params,
                                       constraints=gmvar$model$constraints, change_to=change_to)
  GMVAR(data=gmvar$data, p=gmvar$model$p, M=gmvar$model$M, params=new_params, conditional=gmvar$model$conditional,
        parametrization=change_to, constraints=gmvar$model$constraints, calc_std_errors=TRUE)
}