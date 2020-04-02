library(tidyverse)
library(mosaic)
library(FNN)
news = read.csv("data/online_news.csv")
rmse = function(y, ypred) {
  sqrt(mean(data.matrix((y-ypred)^2)))
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
  
# Fit to the training data

our_model = lm(shares ~ n_tokens_title + num_imgs + num_keywords + 
                 data_channel_is_entertainment + data_channel_is_tech +
                  title_subjectivity + title_sentiment_polarity + avg_negative_polarity, data=news_train)

our_model2 = lm(shares ~ n_tokens_title + title_subjectivity + title_sentiment_polarity + avg_negative_polarity, data=news_train)

our_model3 = lm(shares ~ num_hrefs, data=news_train)

our_model4 = lm(shares ~ n_tokens_title + data_channel_is_entertainment +
                  data_channel_is_world + self_reference_max_shares + 
                  global_rate_positive_words + global_rate_negative_words +
                  min_positive_polarity + max_positive_polarity + 
                  min_negative_polarity + max_negative_polarity +
                  title_subjectivity + title_sentiment_polarity, data=news_train)

our_model5 = lm(shares ~ n_tokens_title + data_channel_is_entertainment +
                  data_channel_is_world + self_reference_max_shares + 
                  global_rate_positive_words + global_rate_negative_words +
                  avg_negative_polarity + 
                  min_negative_polarity + max_negative_polarity +
                  title_subjectivity + title_sentiment_polarity, data=news_train)
# Predictions out of sample
coef(our_model4)
yhat_test = predict(our_model, news_test)
yhat_test2 = predict(our_model2, news_test)
yhat_test3 = predict(our_model3, news_test)
yhat_test4 = predict(our_model4, news_test)
yhat_test5 = predict(our_model5, news_test)

yhat_test_viral = ifelse(yhat_test > 1400, 1, 0) 
news_test_viral = ifelse(news_test$shares > 1400, 1, 0) 

yhat_test_viral2 = ifelse(yhat_test2 > 1400, 1, 0) 
yhat_test_viral3 = ifelse(yhat_test3 > 1400, 1, 0) 
yhat_test_viral4 = ifelse(yhat_test4 > 1400, 1, 0) 
yhat_test_viral5 = ifelse(yhat_test5 > 1400, 1, 0) 

confusion_out = table(y = news_test_viral, yhat = yhat_test_viral)
confusion_out
confusion_out2 = table(y = news_test_viral, yhat = yhat_test_viral2)
confusion_out2
confusion_out3 = table(y = news_test_viral, yhat = yhat_test_viral3)
confusion_out3
confusion_out4 = table(y = news_test_viral, yhat = yhat_test_viral4)
confusion_out4
confusion_out5 = table(y = news_test_viral, yhat = yhat_test_viral5)
confusion_out5




