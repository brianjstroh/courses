library(quanteda)
library(readtext)
library(readr)
library(dplyr)
library(stringi)

load("1grams")
load("2grams")
load("3grams")
load("4grams")
load("5grams")

predict_next<-function(my_phrase){
      my_phrase<-unlist(strsplit(my_phrase, split = " "))
      curr_probs<-data.frame(
            feature = character(),
            prob = numeric()
      )
      if(length(my_phrase)>0){
            if(length(my_phrase)>4){
                  my_phrase <- my_phrase[-(1:(length(my_phrase)-4))]
            }
            my_len<-length(my_phrase)
            if(my_len>3){
                  temp_probs <- select(filter(my_freq5, V1 == my_phrase[my_len-3], V2 == my_phrase[my_len-2], V3 == my_phrase[my_len-1], V4 == my_phrase[my_len]), feature = V5, docfreq)
                  temp_probs$prob <- temp_probs$docfreq/sum(temp_probs$docfreq)
                  curr_probs<-rbind(curr_probs, select(temp_probs,feature,prob))
            }
            if(length(my_phrase)>2){
                  temp_probs <- select(filter(my_freq4, V1 == my_phrase[my_len-2], V2 == my_phrase[my_len-1], V3 == my_phrase[my_len]), feature = V4, docfreq)
                  temp_probs$prob <- temp_probs$docfreq/sum(temp_probs$docfreq)
                  curr_probs<-rbind(curr_probs, select(temp_probs,feature,prob))
            }
            if(length(my_phrase)>1){
                  temp_probs <- select(filter(my_freq3, V1 == my_phrase[my_len-1], V2 == my_phrase[my_len]), feature = V3, docfreq)
                  temp_probs$prob <- temp_probs$docfreq/sum(temp_probs$docfreq)
                  curr_probs<-rbind(curr_probs, select(temp_probs,feature,prob))
            }
            temp_probs <- select(filter(my_freq2, V1 == my_phrase[my_len]), feature = V2, docfreq)
            temp_probs$prob <- temp_probs$docfreq/sum(temp_probs$docfreq)
            curr_probs<-rbind(curr_probs, select(temp_probs,feature,prob))
      } else{
            temp_probs <- my_freq
            temp_probs$prob <- temp_probs$docfreq/sum(temp_probs$docfreq)
            curr_probs<-rbind(curr_probs, select(temp_probs,feature,prob))
      }
      
      
      #gets rid of duplicates and probabilities once these are sorted
      data.frame(Recommendation = unique(unlist(c(unique(select(curr_probs[order(curr_probs$prob, decreasing = TRUE),],feature)),my_freq$feature[1:20])))[1:10])
      
}