#' Measure mean squared error.
#' 
#' Given the ground truth (correct) target values and the estimated target 
#' values, calculates the mean squared error metric.
#'
#' @param y_true A numeric vector; the ground truth (correct) target values.
#' @param y_pred A numeric vector; the estimated target values.
#' @return A numeric vector of length one; the mean squared error metric.
#' @family measure
#' @export
measure_mean_squared_error <- scorer::mean_squared_error

#' Measure Coefficient of Determination (R^2 Score).
#' 
#' Given the ground truth (correct) target values and the estimated target 
#' values, calculates the the R^2 metric.
#' 
#' See here for more information: \url{https://en.wikipedia.org/wiki/Coefficient_of_determination}
#'
#'
#' @param y_true A numeric vector; the ground truth (correct) target values.
#' @param y_pred A numeric vector; the estimated target values.
#' @return A numeric vector of length one; the R^2 metric.
#' @family measure
#' @export
measure_r2_score <- function(y_true, y_pred) {
  measure_cor_score(y_true, y_pred) ^ 2
}

#' Measure Pearsons Correlation Coefficient.
#' 
#' Given the ground truth (correct) target values and the estimated target 
#' values, calculates the correlation metric.
#' 
#' See here for more information: \url{https://en.wikipedia.org/wiki/Pearson_correlation_coefficient}
#'
#' @param y_true A numeric vector; the ground truth (correct) target values.
#' @param y_pred A numeric vector; the estimated target values.
#' @return A numeric vector of length one; the correlation metric.
#' @family measure
#' @export
measure_cor_score <- function(y_true, y_pred) {
  stats::cor(y_true, y_pred)
}

#' Measure Intraclass Correlation Coefficient (ICC(1,1)).
#' 
#' Given the ground truth (correct) target values and the estimated target 
#' values, calculates the ICC metric.
#' 
#' See here for more information: \url{https://en.wikipedia.org/wiki/Pearson_correlation_coefficient}
#'
#' @param y_true A numeric vector; the ground truth (correct) target values.
#' @param y_pred A numeric vector; the estimated target values.
#' @return A numeric vector of length one; the ICC metric.
#' @family measure
#' @export
measure_icc_score <- function(y_true, y_pred) {
  icc_df <- data.frame(y_true = y_true, y_pred = y_pred)
  results <- icc(icc_df, model = "oneway", type = "agreement")
  return(results$value)
}

#' Measure area under the curve.
#' 
#' Given the ground truth (correct) target values and the estimated target 
#' values, calculates the the AUC metric.
#'
#' @param y_true A numeric vector; the ground truth (correct) target values.
#' @param y_pred A numeric vector; the estimated target values.
#' @return A numeric vector of length one; the AUC metric.
#' @family measure
#' @export
measure_area_under_curve <- function(y_true, y_pred) {
  as.numeric(pROC::roc(as.numeric(y_true), as.numeric(y_pred))$auc)
}
