library(tm)
library(qdap)
library(data.table)
library(textreg)
#####################################################################################

unigram <- readRDS("data/final_unigrams.rds")
bigram <- readRDS("data/final_bigrams.rds")
trigram <- readRDS("data/final_trigrams.rds")
quadgram <- readRDS("data/final_quadgrams.rds")
pentagram <- readRDS("data/final_pentagrams.rds")

unigram <- as.data.table(unigram)
bigram <- as.data.table(bigram)
trigram <- as.data.table(trigram)
quadgram <- as.data.table(quadgram)
pentagram <- as.data.table(pentagram)
######################################################################################

clean_corpus <- function(corpus){
      #corpus <- tm_map(corpus, removePunctuation)
      corpus <- tm_map(corpus, stripWhitespace)
      corpus <- tm_map(corpus, removeNumbers)
      corpus <- tm_map(corpus, content_transformer(tolower))
      #corpus <- tm_map(corpus, PlainTextDocument)
      corpus <- tm_map(corpus, content_transformer(function(corpus){corpus <- gsub("[[:punct:]]", replacement = "", x = corpus)}))
      corpus <- tm_map(corpus, content_transformer(replace_abbreviation))
      
      return(corpus)
}
#################################################################################
trim.trailing <- function (x) sub("\\s+$", "", x)

grablast <- function(x, n){
      
      patt = sprintf("\\w+( \\w+){0,%d}$", n-1)
      x <- trim.trailing(x) 
      text <- stringi::stri_extract(x, regex = patt)
      return(text)
}
################################################################################
### clean input ################################################################
library(stringr)
input <- function(text){
      #cleaning input using clean_corpus() and converting back to char vector
      text = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", text)
      text = gsub("@\\w+", "", text)
      text <-  str_replace_all(text," "," ")
      text <- str_replace(text,"RT @*: ","")                  #clean retweets
      text <- str_replace_all(text,"#[a-z,A-Z]*","")     # Get rid of hashtags
      text <- gsub('http.*\\s*', '', text)
      #text <- gsub('@\\w+', '', text)                    #get rid of other screen-names 
      
      corpus_input <- VCorpus(VectorSource(text))
      clean_corpus_input <- clean_corpus(corpus_input)      
      input_vec <- convert.tm.to.character(clean_corpus_input)
      
      input_vec <- trim.trailing(input_vec)
      #input_vec <- grablast(input_vec, 4)
      
      return(input_vec)
      }

########################################################################################
### Prediction #######################################################################
prediction <- function(x){

input_vec <- input(x)

if(sum(pentagram$initial_words %in% input_vec)>0)
{     
      count5grams <- pentagram[initial_words %in% input_vec] 
      input4grams <- quadgram[ngrams %in% input_vec]
      count5grams$score <- rep(1, nrow(count5grams))
      
      count5grams$score <- count5grams$frequency/input4grams$frequency
      count5grams$score <- sort(count5grams$score, decreasing = T)
      #return(count5grams)
      if(nrow(count5grams) > 5)
      {
            pred <- count5grams[,c("last_word","score")]
            return(pred)
      }else   #backoff to 4gram model
            {
                   input_vec <- grablast(input_vec, 3) 
                   count4grams <- quadgram[initial_words %in% input_vec] 
                   input3grams <- trigram[ngrams %in% input_vec]
                   count4grams$score <- rep(1, nrow(count4grams))
                   
                   count4grams$score <- 0.4*(count4grams$frequency/input3grams$frequency)
                   count4grams$score <- sort(count4grams$score, decreasing = T)
                   
                   if(nrow(count4grams) > 5)
                   {
                         pred <- count4grams[,c("last_word","score")]
                         return(pred)
                   }else  #backoff to 3gram model
                        {
                              input_vec <- grablast(input_vec, 2) 
                              count3grams <- trigram[initial_words %in% input_vec] 
                              input2grams <- bigram[ngrams %in% input_vec]
                              count3grams$score <- rep(1, nrow(count3grams))
                              
                              count3grams$score <- 0.4*0.4*(count3grams$frequency/input2grams$frequency)
                              count3grams$score <- sort(count3grams$score, decreasing = T)
                              
                              if(nrow(count3grams) > 5)
                              {
                                    pred <- count3grams[,c("last_word","score")]
                                    return(pred)
                              }else #backoff to 2gram model
                                    {
                                          input_vec <- grablast(input_vec, 1) 
                                          count2grams <- bigram[initial_words %in% input_vec] 
                                          input1grams <- unigram[ngrams %in% input_vec]
                                          count2grams$score <- rep(1, nrow(count2grams))
                                          
                                          count2grams$score <- 0.4*0.4*0.4*(count2grams$frequency/input1grams$frequency)
                                          count2grams$score <- sort(count2grams$score, decreasing = T)
                                          
                                          if(nrow(count2grams) > 5)
                                          {
                                                pred <- count2grams[c("last_word","score")]
                                                return(pred)
                                          }else #backoff to 1gram model
                                                {
                                                      count1grams <- head(unigram,5)
                                                      pred <- count1grams[,c("ngrams")]
                                                      return(pred)
                                                      
                                                } #end of 1gram
                                    } #end of backoff 2gram
                        } #end of backoff 3gram
            } #end of backoff 4gram

      
### end of pentagram  ##############################################################          
}
else
{
      input_vec <- grablast(input_vec, 3)
      if(sum(input_vec %in% quadgram$initial_words)>0)
      {
             
            count4grams <- quadgram[initial_words %in% input_vec] 
            input3grams <- trigram[ngrams %in% input_vec]
            count4grams$score <- rep(1, nrow(count4grams))
            
            count4grams$score <- count4grams$frequency/input3grams$frequency
            count4grams$score <- sort(count4grams$score, decreasing = T)
            
            if(nrow(count4grams) > 5)
            {
                  pred <- count4grams[,c("last_word","score")]
                  return(pred)
            }else  #backoff to 3gram model
            {
                  input_vec <- grablast(input_vec, 2) 
                  count3grams <- trigram[initial_words %in% input_vec] 
                  input2grams <- bigram[ngrams %in% input_vec]
                  count3grams$score <- rep(1, nrow(count3grams))
                  
                  count3grams$score <- 0.4*(count3grams$frequency/input2grams$frequency)
                  count3grams$score <- sort(count3grams$score, decreasing = T)
                  
                  if(nrow(count3grams) > 5)
                  {
                        pred <- count3grams[,c("last_word","score")]
                        return(pred)
                  }else #backoff to 2gram model
                  {
                        input_vec <- grablast(input_vec, 1) 
                        count2grams <- bigram[initial_words %in% input_vec] 
                        input1grams <- unigram[ngrams %in% input_vec]
                        count2grams$score <- rep(1, nrow(count2grams))
                        
                        count2grams$score <- 0.4*0.4*(count2grams$frequency/input1grams$frequency)
                        count2grams$score <- sort(count2grams$score, decreasing = T)
                        
                        if(nrow(count2grams) > 5)
                        {
                              pred <- count2grams[,c("last_word","score")]
                              return(pred)
                        }else #backoff to 1gram model
                        {
                              count1grams <- head(unigram,5)
                              pred <- count1grams[,c("ngrams")]
                              return(pred)
                              
                        } #end of 1gram
                  } #end of backoff 2gram
            } #end of backoff 3gram

### end of quadgram #############################################################        
      }
      else
      {      
            input_vec <- grablast(input_vec, 2) 
            if(sum(input_vec %in% trigram$initial_words)>0)
            {
                  count3grams <- trigram[initial_words %in% input_vec] 
                  input2grams <- bigram[ngrams %in% input_vec]
                  count3grams$score <- rep(1, nrow(count3grams))
                  
                  count3grams$score <- count3grams$frequency/input2grams$frequency
                  count3grams$score <- sort(count3grams$score, decreasing = T)
                  
                  if(nrow(count3grams) > 5)
                  {
                        pred <- count3grams[,c("last_word","score")]
                        return(pred)
                  }else #backoff to 2gram model
                  {
                        input_vec <- grablast(input_vec, 1) 
                        count2grams <- bigram[initial_words %in% input_vec] 
                        input1grams <- unigram[ngrams %in% input_vec]
                        count2grams$score <- rep(1, nrow(count2grams))
                        
                        count2grams$score <- 0.4*(count2grams$frequency/input1grams$frequency)
                        count2grams$score <- sort(count2grams$score, decreasing = T)
                        
                        if(nrow(count2grams) > 5)
                        {
                              pred <- count2grams[,c("last_word","score")]
                              return(pred)
                        }else #backoff to 1gram model
                        {
                              count1grams <- head(unigram,5)
                              pred <- count1grams[,c("ngrams")]
                              return(pred)
                              
                        } #end of 1gram
                  } #end of backoff 2gram

### end of trigram ##############################################################            
            }
            else
            {
                  input_vec <- grablast(input_vec, 1) 
                  if(sum(input_vec %in% bigram$initial_words)>0)
                  {
                        count2grams <- bigram[initial_words %in% input_vec] 
                        input1grams <- unigram[ngrams %in% input_vec]
                        count2grams$score <- rep(1, nrow(count2grams))
                        
                        count2grams$score <- count2grams$frequency/input1grams$frequency
                        count2grams$score <- sort(count2grams$score, decreasing = T)
                        
                        if(nrow(count2grams) > 5)
                        {
                              pred <- count2grams[,c("last_word","score")]
                              return(pred)
                        }else #backoff to 1gram model
                        {
                              count1grams <- head(unigram,5)
                              pred <- count1grams[,c("ngrams")]
                              return(pred)
                              
                        } #end of 1gram
                        
### end of bigram ###############################################################    
                  }else
                  {
                        count1grams <- head(unigram,5)
                        pred <- count1grams[,c("ngrams")]
                        return(pred)
                  }
            } #end of else trigram model
      } #end of else quadgram model
} #end of else pentagram model
}### end of function
