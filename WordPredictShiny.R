
# Loading N-grams list
nGramList <- readRDS("nGramList.rds")



### Lets define function to return table with predicted wirds sorted by the count of occurencies

WordPredictTable <- function(request_text) {
        
        words_num <- str_count(request_text, "\\S+")

        if (words_num == 0 ) {
               emptydf <- data.frame("count" = ";)", "last" = "<- please enter the text in the box ;)", stringsAsFactors=FALSE)
               result <- emptydf
               
               return(result)
       } 
      
        request_text <- tolower(request_text) #decapitalizing words
        request_text <- Trim(clean(request_text)) #cleaning spaces (leadint, trailing, double)
        request_text<- gsub('[[:punct:] ]+',' ', request_text) #removing punctuation
        
       if (words_num >= 3) {
                words_num <- 3
                } 
        
        
        {
                for (i in words_num:1) {
                nGramToUse <- as.data.frame(nGramList[words_num+1])
                result <- nGramToUse[str_detect(nGramToUse$first, word(request_text,-words_num, -1)),]
                        if (length(result$last)==0) {
                                        words_num <- words_num - 1
                                        
                                        }
                }
                
                return(result)
        }
}
