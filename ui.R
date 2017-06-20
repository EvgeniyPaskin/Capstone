#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)


# User Interface script

shinyUI(fluidPage(
        
        theme = shinytheme("cosmo"),
        titlePanel("Next-Word-Prediction | Coursera | Capstone | V 2.0"),
        
        # Sidebar layout
        sidebarLayout(
                
                sidebarPanel(
                        
                        # Text input
                        textInput("text", label = ("Enter you base text "), value = "Coursera is the")),
                        
                        
                
                # Mainpanel ####
                
                mainPanel(
                        
                        wellPanel(
                                
                                # Table form output of top results
                                dataTableOutput('table')),
                                
                                # Wordcloud output
                                plotOutput('wordcloud'),
                                
                                
                                # Time for Prediction
                                textOutput('timespent'),
                        
                                # Slide Deck presentation
                                helpText(a("Slide Deck about the app",
                                           href='http://rpubs.com/EPaskin/Capstone', 
                                           target = '_blank')
                                ),
                                
                                # Link to gidhub
                                helpText(a('Git Hub repository',
                                           href='https://github.com/EvgeniyPaskin/Capstone',
                                           target = '_blank')
                                )
                                
                                
                        )
                ) 
        )
)
