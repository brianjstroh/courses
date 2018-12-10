#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

source("Predict_Next.R")


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
      
      next_words <- reactive({
            predict_next(input$phrase)
      })
      
      output$words <- renderTable({
            #head(next_words(), n = input$obs)
            head(next_words(), n = 20)
      })
})
