library(tidyverse)
library(mosaic)
library(FNN)
news = read.csv("data/online_news.csv")
rmse = function(y, ypred) {
  sqrt(mean(data.matrix((y-ypred)^2)))
}

is.nan.data.frame <- function(x)
  do.call(cbind, lapply(x, is.nan))

pcg = function(table) {
  (table[1] + table[4])/(table[1] + table[2] + table[3] + table[4])
}

set.seed(3)

news = online_news
sum(news$shares > 1400)
sum(news$shares <= 1400)
n = nrow(news)
n_train = round(0.8*n)  # round to nearest integer
n_test = n - n_train
n_train = round(0.8*n)  # round to nearest integer
n_test = n - n_train
print(n)

# re-split into train and test cases with the same sample sizes
train_cases = sample.int(n, n_train, replace=FALSE)
test_cases = setdiff(1:n, train_cases)
news_train = news[train_cases,]
news_test = news[test_cases,]
  



Xtrain = model.matrix(~ num_imgs + n_tokens_title + data_channel_is_entertainment +
                        data_channel_is_world + self_reference_avg_sharess + 
                        global_rate_positive_words + global_rate_negative_words +
                        avg_negative_polarity + data_channel_is_socmed, data=news_train)
Xtest = model.matrix(~ num_imgs + n_tokens_title + data_channel_is_entertainment +
                       data_channel_is_world + self_reference_avg_sharess + 
                       global_rate_positive_words + global_rate_negative_words +
                       avg_negative_polarity + data_channel_is_socmed, data=news_test)

ytrain = news_train$shares
ytest = news_test$shares

scale_train = apply(Xtrain, 2, sd)
Xtilde_train = scale(Xtrain, scale = scale_train)
Xtilde_test = scale(Xtest, scale = scale_train)

Xtilde_train[is.nan(Xtilde_train)] <- 0
Xtilde_test[is.nan(Xtilde_test)] <- 0
head(Xtrain, 2)
head(Xtilde_train, 2) %>% round(3)
knn_model = knn.reg(Xtilde_train, Xtilde_test, ytrain, k=5)




news_test_viral = ifelse(news_test$shares > 1400, 1, 0) 

knn_test_viral = ifelse(knn_model$pred > 1400, 1, 0) 

confusion_out = table(y = news_test_viral, o = knn_test_viral)
confusion_out
pec = pcg(confusion_out)
print("percentage correct:")
pec
print("true positive rate:")
confusion_out[4]/(confusion_out[2] +confusion_out[4])
print("false positive rate:") 
confusion_out[2]/(confusion_out[2] +confusion_out[4])

i <- 3
while(i <= 50){
  train_cases = sample.int(n, n_train, replace=FALSE)
  test_cases = setdiff(1:n, train_cases)
  news_train = news[train_cases,]
  news_test = news[test_cases,]
  
  
  
  
  Xtrain = model.matrix(~ num_imgs + n_tokens_title + data_channel_is_entertainment +
                          data_channel_is_world + self_reference_avg_sharess + 
                          global_rate_positive_words + global_rate_negative_words +
                          avg_negative_polarity + data_channel_is_socmed, data=news_train)
  Xtest = model.matrix(~ num_imgs + n_tokens_title + data_channel_is_entertainment +
                         data_channel_is_world + self_reference_avg_sharess + 
                         global_rate_positive_words + global_rate_negative_words +
                         avg_negative_polarity + data_channel_is_socmed, data=news_test)
  
  ytrain = news_train$shares
  ytest = news_test$shares
  
  scale_train = apply(Xtrain, 2, sd)
  Xtilde_train = scale(Xtrain, scale = scale_train)
  Xtilde_test = scale(Xtest, scale = scale_train)
  Xtilde_train[is.nan(Xtilde_train)] <- 0
  Xtilde_test[is.nan(Xtilde_test)] <- 0
  head(Xtrain, 2)
  head(Xtilde_train, 2) %>% round(3)
  knn_model = knn.reg(Xtilde_train, Xtilde_test, ytrain, k=5)
  
  
  
  
  news_test_viral = ifelse(news_test$shares > 1400, 1, 0) 
  
  knn_test_viral = ifelse(knn_model$pred > 1400, 1, 0) 
  
  new_confusion_out = table(y = news_test_viral, o = knn_test_viral)
  
  confusion_out[1] = (confusion_out[1]+new_confusion_out[1])/2
  confusion_out[2] = (confusion_out[2]+new_confusion_out[2])/2
  confusion_out[3] = (confusion_out[3]+new_confusion_out[3])/2
  confusion_out[4] = (confusion_out[4]+new_confusion_out[4])/2
  
  pec = (pec + pcg(new_confusion_out))/2
  i = i + 1
}

confusion_out
pec
print("true positive rate:")
confusion_out[4]/(confusion_out[2] +confusion_out[4])
print("false positive rate:") 
confusion_out[2]/(confusion_out[2] +confusion_out[4])







