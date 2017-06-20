#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
# Libraries and options ####

source('WordPredictShiny.R')

library(shiny)
library(wordcloud)
library(RColorBrewer)
#library(readr)
#library(tidytext) 
#library(dplyr)
#library(ggplot2)
#library(tidyr)
library(stringr)
library(qdap)

# Swith on/off error messages
options(shiny.sanitize.errors = FALSE)

# Server mechanics desctiption

shinyServer(function(input, output) {
        
        # Predict text on the user's input
        prediction =  reactive( {
                

                
                # Get text input
                request_text <- input$text
                
                #start timer
                beginning <- Sys.time()
                
                # Parse input to prediction function
                prediction_draft <- WordPredictTable(request_text)
                
                #end timer
                ending <- Sys.time()
                
                
                prediction_draft <- prediction_draft[1:length(prediction_draft$last),]
                prediction <- prediction_draft[,c("last","count")]
 
        })
 
        
               
        # Output data table ####
        

        
        output$table <- renderDataTable(prediction(),
                                       option = list(pageLength = 5,
                                                     lengthMenu = list(c(5, 10, 20), c('5', '10', '20')),
                                                     columnDefs = list(list(visible = T, targets = 1)),
                                                     searching = F
                                                     
                                       )
        )
        
        # Output word cloud ####
        
          wordcloud_rep = repeatable(wordcloud)
          output$wordcloud = renderPlot(
                  wordcloud_rep(
                          prediction()$last,
                          prediction()$count,
                          colors = brewer.pal(8, 'Dark2'),
                          scale=c(8, 0.1),
                          max.words = 30
                 )
         )
})