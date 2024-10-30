library(testthat)
library(MASS)

data("iris")

# Test for invalid input
test_that("ridgereg rejects erroneous input", {
  expect_error(ridgereg$new(formula = Petal.Length ~ Species, data = irfsfdis, lambda = 0.1))
  expect_error(ridgereg$new(formula = Petal.Length ~ Speciees, data = iris, lambda = 0.1))
})

# Test the model class
test_that("class is correct", {
  ridge_model <- ridgereg$new(Petal.Length ~ Species, data = iris, data_name = "iris", lambda = 0.1)
  expect_true(class(ridge_model) == "ridgereg")
})

# Test the predict method
test_that("predict() method works with new data", {
  ridge_model <- ridgereg$new(Petal.Length ~ Species, data = iris, data_name = "iris", lambda = 0.1)

  # Create new data, selecting only the necessary variables
  new_data <- iris[, c("Species", "Petal.Length", "Petal.Width", "Sepal.Length", "Sepal.Width")]
  new_data <- new_data[1:3, ]  # Select the first three rows for prediction

  # Make predictions
  new_predictions <- ridge_model$predict(newdata = new_data)
  expect_equal(length(new_predictions), nrow(new_data))
})

# Test the coef() method
test_that("coef() method works", {
  ridge_model <- ridgereg$new(Petal.Length ~ Species, data = iris, data_name = "iris", lambda = 0.1)
  coefficients <- ridge_model$coef()
  expect_true(length(coefficients) > 0)
  expect_type(coefficients, "double")
})

# Test that ridge regression coefficients are similar to those from lm.ridge()
test_that("ridge regression coefficients are similar to lm.ridge()", {
  lm_ridge <- MASS::lm.ridge(Petal.Length ~ Species, data = iris, lambda = 0.1)
  ridge_model <- ridgereg$new(Petal.Length ~ Species, data = iris, data_name = "iris", lambda = 0.1)

  # Get the coefficients from the ridge_model and assign names
  ridge_coefs <- ridge_model$coef()
  names(ridge_coefs) <- colnames(model.matrix(Petal.Length ~ Species, iris))  # Ensure name consistency

  lm_ridge_coefs <- coef(lm_ridge)

  # Remove the intercept term for comparison
  ridge_coefs_no_intercept <- ridge_coefs[-1]  # Remove intercept
  lm_ridge_coefs_no_intercept <- lm_ridge_coefs[-1]  # Remove intercept

  # Use expect_equal to compare, allowing for a certain tolerance
  expect_equal(round(ridge_coefs_no_intercept, 2), round(lm_ridge_coefs_no_intercept, 2),
               info = "Coefficients should be similar to those from lm.ridge", tolerance = 0.02)
})
