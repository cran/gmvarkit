#' @describeIn GMVAR Log-likelihood method
#' @inheritParams plot.gmvar
#' @param object object of class \code{'gmvar'} generated by \code{fitGMVAR} or \code{GMVAR}.
#' @export
logLik.gmvar <- function(object, ...) object$loglik


#' @describeIn GMVAR residuals method to extract multivariate quantile residuals
#' @inheritParams logLik.gmvar
#' @export
residuals.gmvar <- function(object, ...) {
  res <- object$quantile_residuals
  colnames(res) <- colnames(object$data)
  res
}


#' @describeIn GMVAR summary method
#' @inheritParams logLik.gmvar
#' @inheritParams print.gmvar
#' @export
summary.gmvar <- function(object, ..., digits=2) {
  gmvar <- object
  structure(list(gmvar=gmvar,
                 abs_boldA_eigens=get_boldA_eigens(gmvar),
                 omega_eigens=get_omega_eigens(gmvar),
                 regime_means=get_regime_means(gmvar),
                 digits=digits),
            class="gmvarsum")
}
