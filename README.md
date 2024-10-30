<!-- badges: start -->
[![R-CMD-check](https://github.com/Quanlin222/linreg/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/Quanlin222/linreg/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

# Linreg package

The `linreg` package is designed to handle linear regression models. 
It utilizes QR decomposition to provide basic functionality and implements results as an RC class. 
The package also incorporates an object-oriented ridgereg() function to manage special functions such as `print()`, `predict()`, and `coef()`.

## 1.1 Install package

devtools::install_github("Quanlin222/linreg")

## 1.2 Load package

library(linreg)

## 1.3 Load data

data(iris)

my_ridgereg <- ridgereg_fit(Petal.Length ~ Species, data = iris, lambda = 0.1)

## 1.4 Run the ridgereg() function

### 1.4.1 Print out the coefficients and coefficient names:

my_ridgereg$print()

### 1.4.2 The predicted values y_hat:

my_ridgereg$predict()


### 1.4.3 The coefficients as a named vector:

my_ridgereg$coef()
