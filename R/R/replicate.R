#' TO BE EDITED.
#' 
#' TO BE EDITED.
#'
#' @param fit_model TO BE EDITED.
#' @param extract_coefficients TO BE EDITED.
#' @param X TO BE EDITED.
#' @param y TO BE EDITED.
#' @param n_samples TO BE EDITED.
#' @param progress_bar TO BE EDITED.
#' @param parallel TO BE EDITED.
#' @return TO BE EDITED.
#' @export
replicate_coefficients <- function(fit_model, extract_coefficients, 
                                   preprocessor, X, y, 
                                   categorical_variables = NULL, 
                                   n_samples = 1000, progress_bar = TRUE, 
                                   n_core = 1, ...) {
  # Print an informative message
  if (progress_bar) {
    parallel_string <- ifelse(n_core > 1, " in parallel:", ":")
    print(paste0("Replicating coefficients", parallel_string))
  }
  
  # Preprocess data
  result <- preprocessor(list(X = X), categorical_variables)
  X <- result[["X"]]

  # Define closure
  replicate_coefficient <- function(i) {
    model <- fit_model(X, y, ...)
    coef <- extract_coefficients(model)
    coef
  }
  
  # Identify which looping mechanism to use
  looper <- identify_looper(progress_bar, n_core)
  
  # Loop over number of iterations
  output <- looper(1:n_samples, replicate_coefficient)
  
  # Combine list of data.frames into one data.frame; 
  # structure should be a data.frame of n_samples by ncol(X)
  output <- do.call(rbind, output)
  output
}

#' TO BE EDITED.
#' 
#' TO BE EDITED.
#'
#' @param fit_model TO BE EDITED.
#' @param predict_model TO BE EDITED.
#' @param X_train TO BE EDITED.
#' @param y_train TO BE EDITED.
#' @param X_test TO BE EDITED.
#' @param n_samples TO BE EDITED.
#' @param progress_bar TO BE EDITED.
#' @param parallel TO BE EDITED.
#' @return TO BE EDITED.
#' @export
replicate_predictions <- function(fit_model, predict_model, preprocessor, 
                                  X_train, y_train, X_test, 
                                  categorical_variables = NULL, 
                                  n_samples = 1000, progress_bar = TRUE, 
                                  n_core = 1, ...) {
  # Handle progress bar
  if (progress_bar) {
    print(paste0("Replicating predictions", ifelse(n_core > 1, " in parallel:", ":")))
  }
  
  # Preprocess data
  result <- preprocessor(list(X_train = X_train, X_test = X_test), 
                         categorical_variables = categorical_variables)
  X_train <- result[["X_train"]]
  X_test <- result[["X_test"]]
  
  # Define closure
  replicate_prediction <- function(i) {
    # Fit model with the training set
    results <- fit_model(X_train, y_train, ...)
    
    # Save predictions
    list(y_train_predictions = predict_model(results, X_train), 
         y_test_predictions = predict_model(results, X_test))
  }
  
  # Identify which looping mechanism to use
  looper <- identify_looper(progress_bar, n_core)
  
  # Loop over number of iterations
  output <- looper(1:n_samples, replicate_prediction)
  
  y_train_predictions <- lapply(output, function(x) x$y_train_predictions)
  y_test_predictions <- lapply(output, function(x) x$y_test_predictions)
  
  y_train_predictions <- t(matrix(unlist(y_train_predictions), 
                                  ncol = nrow(X_train), byrow = TRUE))
  y_test_predictions <- t(matrix(unlist(y_test_predictions), 
                                 ncol = nrow(X_test), byrow = TRUE))
  
  list(y_train_predictions = y_train_predictions, 
       y_test_predictions = y_test_predictions)
}

#' TO BE EDITED.
#' 
#' TO BE EDITED.
#'
#' @param fit_model TO BE EDITED.
#' @param predict_model TO BE EDITED.
#' @param predict_model TO BE EDITED.
#' @param X TO BE EDITED.
#' @param y TO BE EDITED.
#' @param n_divisions TO BE EDITED.
#' @param n_iterations TO BE EDITED.
#' @param progress_bar TO BE EDITED.
#' @param parallel TO BE EDITED.
#' @return TO BE EDITED.
#' @export
replicate_metrics <- function(fit_model, predict_model, sampler, preprocessor, 
                              measure, X, y, categorical_variables = NULL, 
                              n_divisions = 1000, n_iterations = 100, 
                              progress_bar = TRUE, n_core = 1, ...) {
  # Handle progress bar
  if (progress_bar) {
    print(paste0("Replicating metrics", ifelse(n_core > 1, " in parallel:", ":")))
  }
  
  # Identify which looping mechanism to use
  looper <- identify_looper(progress_bar, n_core)
  
  # Define closure
  replicate_metric <- function(i) {
    # Split data
    split_data <- sampler(X, y)
    X_train <- split_data[["X_train"]]
    X_test <- split_data[["X_test"]]
    y_train <- split_data[["y_train"]]
    y_test <- split_data[["y_test"]]
    
    # Preprocess data
    result <- preprocessor(list(X_train = X_train, X_test = X_test), 
                           categorical_variables = categorical_variables)
    X_train <- result[["X_train"]]
    X_test <- result[["X_test"]]
    
    # Create temporary containers
    train_metrics <- numeric()
    test_metrics <- numeric()
    
    # Loop over number of iterations
    output_iterations <- lapply(1:n_iterations, function(i) {
      # Fit estimator with the training set
      results <- fit_model(X_train, y_train, ...)
      
      # Generate scores for training and test sets
      y_train_predictions <- predict_model(results, X_train)
      y_test_predictions <- predict_model(results, X_test)
      
      # Save metrics
      train_metric <- measure(y_train, y_train_predictions)
      test_metric <- measure(y_test, y_test_predictions)
      list(train_metric = train_metric, test_metric = test_metric)
    })
    
    # Take average of metrics
    train_metrics <- unlist(lapply(output_iterations, function(x) x$train_metric))
    test_metrics <- unlist(lapply(output_iterations, function(x) x$test_metric))
    
    # Save mean of metrics
    list(mean_train_metric = mean(train_metrics), 
         mean_test_metric = mean(test_metrics))
  }
  
  # Loop over number of divisions
  output_divisions <- looper(1:n_divisions, replicate_metric)
  
  mean_train_metrics <- unlist(lapply(output_divisions, function(x) x$mean_train_metric))
  mean_test_metrics <- unlist(lapply(output_divisions, function(x) x$mean_test_metric))
  
  list(mean_train_metrics = mean_train_metrics, 
       mean_test_metrics = mean_test_metrics)
}

#' TO BE EDITED.
#' 
#' TO BE EDITED.
#'
#' @param fit_model TO BE EDITED.
#' @param predict_model TO BE EDITED.
#' @param predict_model TO BE EDITED.
#' @param X TO BE EDITED.
#' @param y TO BE EDITED.
#' @param n_divisions TO BE EDITED.
#' @param n_iterations TO BE EDITED.
#' @param progress_bar TO BE EDITED.
#' @param parallel TO BE EDITED.
#' @return TO BE EDITED.
#' @export
replicate_aucs <- function(fit_model, predict_model, sampler, preprocessor, X, y, 
                           categorical_variables = NULL, 
                           n_divisions = 1000, n_iterations = 100, 
                           progress_bar = TRUE, n_core = 1, ...) {
  replicate_metrics(fit_model = fit_model, predict_model = predict_model, 
                    sampler = sampler, preprocessor = preprocessor, 
                    measure = area_under_roc_curve, 
                    X = X, y = y, categorical_variables = categorical_variables, 
                    n_divisions = n_divisions, 
                    n_iterations = n_iterations, progress_bar = progress_bar, 
                    n_core = n_core, ...)
}

#' TO BE EDITED.
#' 
#' TO BE EDITED.
#'
#' @param fit_model TO BE EDITED.
#' @param predict_model TO BE EDITED.
#' @param X TO BE EDITED.
#' @param y TO BE EDITED.
#' @param n_divisions TO BE EDITED.
#' @param n_iterations TO BE EDITED.
#' @param progress_bar TO BE EDITED.
#' @param parallel TO BE EDITED.
#' @return TO BE EDITED.
#' @export
replicate_mses <- function(fit_model, predict_model, sampler, preprocessor, X, y, 
                           categorical_variables = NULL, 
                           n_divisions = 1000, n_iterations = 100, 
                           progress_bar = TRUE, n_core = 1, ...) {
  replicate_metrics(fit_model = fit_model, predict_model = predict_model, 
                    sampler = sampler, preprocessor = preprocessor, 
                    measure = scorer::mean_squared_error, 
                    X = X, y = y, categorical_variables = categorical_variables, 
                    n_divisions = n_divisions, 
                    n_iterations = n_iterations, progress_bar = progress_bar, 
                    n_core = n_core, ...)
}

#' TO BE EDITED.
#' 
#' TO BE EDITED.
#'
#' @return TO BE EDITED.
#' @export
area_under_roc_curve <- function(y_true, y_pred) {
  as.numeric(pROC::roc(y_true, y_pred)$auc)
}