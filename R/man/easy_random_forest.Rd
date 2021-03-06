% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/random_forest.R
\name{easy_random_forest}
\alias{easy_random_forest}
\title{Easily build and evaluate a random forest regression model.}
\usage{
easy_random_forest(.data, dependent_variable, family = "gaussian",
  resample = NULL, preprocess = NULL, measure = NULL,
  exclude_variables = NULL, categorical_variables = NULL,
  train_size = 0.667, foldid = NULL, n_samples = 1000,
  n_divisions = 1000, n_iterations = 10, random_state = NULL,
  progress_bar = TRUE, n_core = 1, ...)
}
\arguments{
\item{.data}{A data.frame; the data to be analyzed.}

\item{dependent_variable}{A character vector of length one; the dependent variable for this analysis.}

\item{family}{A character vector of length one; the type of regression to run on the data. Choices are one of c("gaussian", "binomial"). Defaults to "gaussian".}

\item{resample}{A function; the function for resampling the data. Defaults to NULL.}

\item{preprocess}{A function; the function for preprocessing the data. Defaults to NULL.}

\item{measure}{A function; the function for measuring the results. Defaults to NULL.}

\item{exclude_variables}{A character vector; the variables from the data set to exclude. Defaults to NULL.}

\item{categorical_variables}{A character vector; the variables that are categorical. Defaults to NULL.}

\item{train_size}{A numeric vector of length one; specifies what proportion of the data should be used for the training data set. Defaults to 0.667.}

\item{foldid}{A vector with length equal to \code{length(y)} which identifies cases belonging to the same fold.}

\item{n_samples}{An integer vector of length one; specifies the number of times the coefficients and predictions should be replicated. Defaults to 1000.}

\item{n_divisions}{An integer vector of length one; specifies the number of times the data should be divided when replicating the error metrics. Defaults to 1000.}

\item{n_iterations}{An integer vector of length one; during each division, specifies the number of times the predictions should be replicated. Defaults to 10.}

\item{random_state}{An integer vector of length one; specifies the seed to be used for the analysis. Defaults to NULL.}

\item{progress_bar}{A logical vector of length one; specifies whether to display a progress bar during calculations. Defaults to TRUE.}

\item{n_core}{An integer vector of length one; specifies the number of cores to use for this analysis. Currenly only works on Mac OSx and Unix/Linux systems. Defaults to 1.}

\item{...}{Arguments to be passed to \code{\link[randomForest]{randomForest}}. See that function's documentation for more details.}
}
\value{
A list with the following values:
\describe{
\item{resample}{A function; the function for resampling the data.}
\item{preprocess}{A function; the function for preprocessing the data.}
\item{measure}{A function; the function for measuring the results.}
\item{fit_model}{A function; the function for fitting the model to the data.}
\item{extract_coefficients}{A function; the function for extracting coefficients from the model.}
\item{predict_model}{A function; the function for generating predictions on new data from the model.}
\item{plot_predictions}{A function; the function for plotting predictions generated by the model.}
\item{plot_metrics}{A function; the function for plotting metrics generated by scoring the model.}
\item{data}{A data.frame; the original data.}
\item{X}{A data.frame; the full dataset to be used for modeling.}
\item{y}{A vector; the full response variable to be used for modeling.}
\item{X_train}{A data.frame; the train dataset to be used for modeling.}
\item{X_test}{A data.frame; the test dataset to be used for modeling.}
\item{y_train}{A vector; the train response variable to be used for modeling.}
\item{y_test}{A vector; the test response variable to be used for modeling.}
\item{predictions_train}{A (nrow(X_train), n_samples) matrix; the train predictions.}
\item{predictions_test}{A (nrow(X_test), n_samples) matrix; the test predictions.}
\item{predictions_train_mean}{A vector; the mean train predictions.}
\item{predictions_test_mean}{A vector; the mean test predictions.}
\item{plot_predictions_train_mean}{A ggplot object; the plot of the mean train predictions.}
\item{plot_predictions_test_mean}{A ggplot object; the plot of the mean test predictions.}
\item{metrics_train_mean}{A vector of length n_divisions; the mean train metrics.}
\item{metrics_test_mean}{A vector of length n_divisions; the mean test metrics.}
\item{plot_metrics_train_mean}{A ggplot object; the plot of the mean train metrics.}
\item{plot_metrics_test_mean}{A ggplot object; the plot of the mean test metrics.}
}
}
\description{
Easily build and evaluate a random forest regression model.
}
\examples{
library(easyml) # https://github.com/CCS-Lab/easyml

# Gaussian
data("prostate", package = "easyml")
results <- easy_random_forest(prostate, "lpsa", 
                              n_samples = 10L, 
                              n_divisions = 10, 
                              n_iterations = 2, 
                              random_state = 12345, n_core = 1)

# Binomial
data("cocaine_dependence", package = "easyml")
results <- easy_random_forest(cocaine_dependence, "diagnosis", 
                              family = "binomial", 
                              exclude_variables = c("subject"),
                              categorical_variables = c("male"),
                              n_samples = 10, 
                              n_divisions = 10, 
                              n_iterations = 2, 
                              random_state = 12345, n_core = 1)
}
\seealso{
Other recipes: \code{\link{easy_analysis}},
  \code{\link{easy_glmnet}},
  \code{\link{easy_support_vector_machine}}
}

