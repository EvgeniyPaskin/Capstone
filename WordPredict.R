
# Loading libraries

library(tidyverse) # most of required libraries are included in tidyverse, but we'll load them explicitly for code clearance
library(readr)
library(tidytext) 
library(dplyr)
library(ggplot2)
library(tidyr)
library(stringr)


# reading data to R
TWIT <- read_delim("~/Dropbox/_MyProjects/Data Science/Capstone Project/0. DATA/en_US.twitter.txt", 
                   ";", escape_double = FALSE, col_names = FALSE, 
                   trim_ws = TRUE)

NEWS <- read_delim("~/Dropbox/_MyProjects/Data Science/Capstone Project/0. DATA/en_US.news.txt", 
                   ";", escape_double = FALSE, col_names = FALSE, 
                   trim_ws = TRUE)


BLOG <- read_delim("~/Dropbox/_MyProjects/Data Science/Capstone Project/0. DATA/en_US.blogs.txt", 
                   ";", escape_double = FALSE, col_names = FALSE, 
                   trim_ws = TRUE)


### Because text sources differs a lot, we'll random sample from 3 sources of equal size 
nsamp <- 10000
BLOG_S <- BLOG %>% sample_n(nsamp)
NEWS_S <- NEWS %>% sample_n(nsamp)
TWIT_S <- TWIT %>% sample_n(nsamp)
ALLTXT <- rbind(BLOG_S, NEWS_S, TWIT_S)
rm(BLOG_S, NEWS_S, TWIT_S, nsamp)



### Text comes as a vector, we'll combine all text to 1 cell for further processing with Tidytext 

BBB <- as.data.frame(paste(unlist(ALLTXT), collapse =" "))
colnames(BBB) <- c("TXT")


### Lets generate 1 to 4 N-grams with the help of tidytext package
A1GRAM <- unnest_tokens(BBB, a1, TXT, token = "ngrams", n = 1)
A2GRAM <- unnest_tokens(BBB, a2, TXT, token = "ngrams", n = 2)
A3GRAM <- unnest_tokens(BBB, a3, TXT, token = "ngrams", n = 3)
A4GRAM <- unnest_tokens(BBB, a4, TXT, token = "ngrams", n = 4)
#rm(BBB)


### Calculating counts for N-grams. To make our prediction model more lightweight, we'll filter out N-grams occuring once.
A1GRAMF <-      A1GRAM %>% 
                count(a1, sort = TRUE) %>%
                filter(n>1)        


A2GRAMF <-      A2GRAM %>% 
                count(a2, sort = TRUE) %>%
                filter(n>1)        

A3GRAMF <-      A3GRAM %>% 
                count(a3, sort = TRUE) %>%
                filter(n>1)        

A4GRAMF <-      A4GRAM %>% 
                count(a4, sort = TRUE) %>%
                filter(n>1)        

#rm(A1GRAM, A2GRAM, A3GRAM, A4GRAM)

### Naming correction for code clearance 
colnames(A4GRAMF) <- c("word", "count")
colnames(A3GRAMF) <- c("word", "count")
colnames(A2GRAMF) <- c("word", "count")
colnames(A1GRAMF) <- c("word", "count")


### Lets divide 1st column of our N-gram to 2 colums: [N-1 words] and [last word] that will be predicted. For the 1-gram it would be the word itself

A4GRAMF$last <- word(A4GRAMF$word,-1)
A3GRAMF$last <- word(A3GRAMF$word,-1)
A2GRAMF$last <- word(A2GRAMF$word,-1)
A1GRAMF$last <- word(A1GRAMF$word,-1)

A4GRAMF$first <- word(A4GRAMF$word, start = 1, end = 3)
A3GRAMF$first <- word(A3GRAMF$word, start = 1, end = 2)
A2GRAMF$first <- word(A2GRAMF$word, start = 1, end = 1)
A1GRAMF$first <- word(A1GRAMF$word, start = 1, end = 1)



### Lets combine our N-grams with frequency to one list for further use within function
nGramList <- list(A1GRAMF, A2GRAMF, A3GRAMF, A4GRAMF)
saveRDS(nGramList, "~/Dropbox/_MyProjects/Data Science/Capstone Project/ShinyWordPrediction/nGramList.rds")

### Lets define function to return table with predicted wirds sorted by the count of occurencies

WordPredictTable <- function(request_text) {
        
                words_num <- str_count(request_text, "\\S+")
                
                        if (words_num == 0 ) {
                                
                                result <- "Please enter words"
                                return(result)
                        } 
                        
                        if (words_num > 3) {
                        words_num <- 3
                        } 
                        
                
                        {
                        nGramToUse <- as.data.frame(nGramList[words_num+1])
                        result <- nGramToUse[str_detect(nGramToUse$first, word(request_text,-words_num, -1)),]
                        return(result)
                        }
}





