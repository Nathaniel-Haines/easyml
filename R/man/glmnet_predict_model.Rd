% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/glmnet.R
\name{glmnet_predict_model}
\alias{glmnet_predict_model}
\title{Predict values for a penalized regression model.}
\usage{
glmnet_predict_model(results, newx = NULL)
}
\arguments{
\item{results}{The results of \code{\link{glmnet_fit_model_gaussian}} or \code{\link{glmnet_fit_model_binomial}}.}

\item{newx}{A data.frame, the new data to use for predictions.}
}
\value{
A vector, the predicted values for a penalized regression model using the new data.
}
\description{
Predict values for a penalized regression model.
}

