% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot.R
\name{plot_metrics_binomial_area_under_curve}
\alias{plot_metrics_binomial_area_under_curve}
\title{Plot area under the curve (AUC) metrics.}
\usage{
plot_metrics_binomial_area_under_curve(aucs)
}
\arguments{
\item{aucs}{A vector, the area under the curve (AUC) metrics to be plotted as a histogram.}
}
\value{
A ggplot object. This plot may be rendered by outputting it to the command line or modified using ggplot semantics.
}
\description{
Plot area under the curve (AUC) metrics.
}
\seealso{
Other plot: \code{\link{plot_coefficients_processed}},
  \code{\link{plot_metrics_gaussian_cor_score}},
  \code{\link{plot_metrics_gaussian_icc_score}},
  \code{\link{plot_metrics_gaussian_mean_squared_error}},
  \code{\link{plot_metrics_gaussian_r2_score}},
  \code{\link{plot_predictions_binomial}},
  \code{\link{plot_predictions_gaussian}},
  \code{\link{plot_variable_importances_processed}}
}

