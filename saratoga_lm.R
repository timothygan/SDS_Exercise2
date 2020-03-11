library(tidyverse)
library(mosaic)
data(SaratogaHouses)

set.seed(3)
summary(SaratogaHouses)

# Baseline model
lm_small = lm(price ~ bedrooms + bathrooms + lotSize, data=SaratogaHouses)

# 11 main effects
lm_medium = lm(price ~ lotSize + age + livingArea + pctCollege + bedrooms + 
		fireplaces + bathrooms + rooms + heating + fuel + centralAir, data=SaratogaHouses)

# Sometimes it's easier to name the variables we want to leave out
# The command below yields exactly the same model.
# the dot (.) means "all variables not named"
# the minus (-) means "exclude this variable"
lm_medium2 = lm(price ~ . - sewer - waterfront - landValue - newConstruction, data=SaratogaHouses)

coef(lm_medium)
coef(lm_medium2)

# All interactions
# the ()^2 says "include all pairwise interactions"
lm_big = lm(price ~ (. - sewer - waterfront - landValue - newConstruction)^2, data=SaratogaHouses)


####
# Compare out-of-sample predictive performance
####

# Split into training and testing sets
n = nrow(SaratogaHouses)
n_train = round(0.8*n)  # round to nearest integer
n_test = n - n_train
train_cases = sample.int(n, n_train, replace=FALSE)
test_cases = setdiff(1:n, train_cases)
saratoga_train = SaratogaHouses[train_cases,]
saratoga_test = SaratogaHouses[test_cases,]
	
# Fit to the training data
lm1 = lm(price ~ lotSize + bedrooms + bathrooms, data=saratoga_train)
lm2 = lm(price ~ . - sewer - waterfront - landValue - newConstruction, data=saratoga_train)
lm3 = lm(price ~ (. - sewer - waterfront - landValue - newConstruction)^2, data=saratoga_train)

# Predictions out of sample
yhat_test1 = predict(lm1, saratoga_test)
yhat_test2 = predict(lm2, saratoga_test)
yhat_test3 = predict(lm3, saratoga_test)

rmse = function(y, yhat) {
  sqrt( mean( (y - yhat)^2 ) )
}

# Root mean-squared prediction error
rmse(saratoga_test$price, yhat_test1)
rmse(saratoga_test$price, yhat_test2)
rmse(saratoga_test$price, yhat_test3)


# easy averaging over train/test splits
library(mosaic)
library(FNN)

n_train = round(0.8*n)  # round to nearest integer
n_test = n - n_train





rmse_vals = do(100)*{
  
  # re-split into train and test cases with the same sample sizes
  train_cases = sample.int(n, n_train, replace=FALSE)
  test_cases = setdiff(1:n, train_cases)
  saratoga_train = SaratogaHouses[train_cases,]
  saratoga_test = SaratogaHouses[test_cases,]
  
  # Fit to the training data
  lm1 = lm(price ~ lotSize + bedrooms + bathrooms, data=saratoga_train)
  lm2 = lm(price ~ . - sewer - waterfront - landValue - newConstruction, data=saratoga_train)
  lm3 = lm(price ~ (. - sewer - waterfront - landValue - newConstruction)^2, data=saratoga_train)
  
  lm_dominate = lm(price ~ lotSize + age + livingArea + pctCollege + 
                     bedrooms + fireplaces + bathrooms + rooms + heating + fuel +
                     centralAir + lotSize:heating + livingArea:rooms + newConstruction + livingArea:newConstruction, data=saratoga_train)
  
  

  
  our_model = lm(price ~ . - fireplaces - sewer - heating, data=saratoga_train)
  
  
  #KNN
  Xtrain = model.matrix(~ . - (price + sewer + fireplaces + heating) - 1, data=saratoga_train)
  Xtest = model.matrix(~ . - (price + sewer + fireplaces + heating) - 1, data=saratoga_test)

  ytrain = saratoga_train$price
  ytest = saratoga_test$price

  scale_train = apply(Xtrain, 2, sd)
  Xtilde_train = scale(Xtrain, scale = scale_train)
  Xtilde_test = scale(Xtest, scale = scale_train)

  head(Xtrain, 2)
  head(Xtilde_train, 2) %>% round(3)
  knn_model = knn.reg(Xtilde_train, Xtilde_test, ytrain, k=7)
  
  # Predictions out of sample
  yhat_test1 = predict(lm1, saratoga_test)
  yhat_test2 = predict(lm2, saratoga_test)
  yhat_test3 = predict(lm3, saratoga_test)
  yhat_test4 = predict(lm_dominate, saratoga_test)
  yhat_test5 = predict(our_model, saratoga_test)

  
  c(rmse(saratoga_test$price, yhat_test1),
    rmse(saratoga_test$price, yhat_test2),
    #rmse(saratoga_test$price, yhat_test3),
    rmse(saratoga_test$price, yhat_test4),
    rmse(saratoga_test$price, yhat_test5),
    rmse(ytest, knn_model$pred))
}

# Xtrain = model.matrix(~ .  - (price + sewer + fireplaces + heating) - 1, data=saratoga_train)
# Xtest = model.matrix(~ .  - (price + sewer + fireplaces + heating) - 1, data=saratoga_test)
# 
# ytrain = saratoga_train$price
# ytest = saratoga_test$price
# 
# scale_train = apply(Xtrain, 2, sd) # calculate std dev for each column
# Xtilde_train = scale(Xtrain, scale = scale_train)
# Xtilde_test = scale(Xtest, scale = scale_train)
# 
# head(Xtrain, 2)
# head(Xtilde_train, 2) %>% round(3)
# 
# library(FNN)
# 
# kframe <- data.frame("K" = c(), "RMEAN" =c())
# i <- 3
# while (i <= 250) {
#   knn_model = knn.reg(Xtilde_train, Xtilde_test, ytrain, k=i)
#   d = data.frame("K" = i, "RMEAN" = rmse(ytest, knn_model$pred))
# 
#   kframe = rbind(kframe, d)
#   i = i + 1
# }
# 
# k_vs_rmean = ggplot(data = kframe) +
#   geom_point(mapping = aes(x = K, y = RMEAN), color='lightgrey') +
#   theme_bw(base_size=18) + geom_path(aes(x = K, y = RMEAN), color='red')
# 
# k_vs_rmean

rmse_vals
colMeans(rmse_vals)
boxplot(rmse_vals)






