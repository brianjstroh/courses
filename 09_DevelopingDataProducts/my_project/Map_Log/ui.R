library(shiny)
library(leaflet)
library(DT)

shinyUI(fluidPage(
      theme = "bootstrap.css",
      h1(strong("Map Log")),
      h4("Author: ",em("Brian Stroh")),
      h4("Date: ",em("November 7th, 2018")),
      br(),
      pageWithSidebar(
            headerPanel(title = "",windowTitle = "Map Log Tool"),
            sidebarPanel(
                  textInput("label","Address Label","-"),
                  textInput("street","Street Address","-"),
                  textInput("city","City","-"),
                  textInput("state","State","-"),
                  textInput("zip","Zip Code","-"),
                  textInput("url","HyperLink","-"),
                  actionButton("add", "Add Location")
            ),
            mainPanel(
                  tabsetPanel(
                        tabPanel("Documentation",
                                 h2("About the Map Log Tool"),
                                 hr(),
                                 p("The map intially includes 5 random points in the Pacific Northwest region as examples."),
                                 p("Input fields set to \'-\' will not be used to look up the address."),
                                 p("At a minimum, the \'City\' field must be completed to add and address marker."),
                                 p("Markers can only be added and not deleleted."),
                                 p("All points are recorded on the \'Logged Location Table\' tab."),
                                 p("All links must be opened in a new tab or window, otherwise the Shiny app will break."),
                                 p("All points are marked on the map using latitude and longitude coordinates, but theses are hidden from the user since they are not useful to most users.")),
                        tabPanel("Current Logged Locations",
                                 leafletOutput("map")),
                        tabPanel("Logged Location Table",
                                 DT::dataTableOutput("address_table")
                        )
                  )
            )
      ),
      p(strong("In each popup link, be sure to right click and open in a new tab/window.")), 
      p(em("Please close this page when you are finished."))
))
