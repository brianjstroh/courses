#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
      theme = "bootstrap.css",
      h1(strong("Predict Next NLP Demo")),
      h4("Author: ",em("Brian Stroh")),
      h4("Date: ",em("December 12th, 2018")),
      br(),
      pageWithSidebar(
            headerPanel(title = "",windowTitle = "Predict Text"),
            sidebarPanel(
                  textInput("phrase","Input phrase: ",""),
                  br(),
                  actionButton("submit", "Predict Next")
            ),
            mainPanel(
                  tabsetPanel(
                        tabPanel("Predict Next Word",
                                 tableOutput("words")),
                        tabPanel("Documentation",
                                 h2("About the Word Predicting Tool"))
                  )
            )
      ),
      p(em("Please close this page when you are finished."))
))
