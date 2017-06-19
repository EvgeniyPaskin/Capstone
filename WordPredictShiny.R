

# Loading N-grams list
nGramList <- readRDS("nGramList.rds")

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

