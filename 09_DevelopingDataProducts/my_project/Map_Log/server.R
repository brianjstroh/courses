#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(dplyr)
library(data.table)
library(DT)
library(urltools)

getLatLong<- function(address){
      if(address$street !="-" && address$city !="-" && address$state !="-" && address$zip !="-"){
            findme<-as.character(paste(address$street,address$city,paste(address$state,paste0(address$zip,"\",null,"),sep=" "),sep=", "))
            address$street<-gsub(" ","+",address$street)
            lookupURL<-paste0("https://www.google.com/maps/place/",address$street,",+",address$city,",+",address$state,"+",address$zip,"/")
      }else if(address$street !="-" && address$city !="-" && address$state !="-"){
            findme<-as.character(paste(address$street,address$city,paste0(address$state,"\",null,"),sep=", "))
            address$street<-gsub(" ","+",address$street)
            lookupURL<-paste0("https://www.google.com/maps/place/",address$street,",+",address$city,",+",address$state,"/")
      }else if(address$city !="-" && address$state !="-"){
            findme<-as.character(paste(address$city,paste0(address$state,"\",null,"),sep=", "))
            lookupURL<-paste0("https://www.google.com/maps/place/",address$city,",+",address$state,"/")
      }else if(address$street !="-"){
            findme<-as.character(paste0(address$street,"\",null,"))
            address$street<-gsub(" ","+",address$street)
            lookupURL<-paste0("https://www.google.com/maps/place/",address$street,"/")
      }else if(address$city !="-"){
            findme<-as.character(paste0(address$city,"\",null,"))
            lookupURL<-paste0("https://www.google.com/maps/place/",address$city,"/")
      }
      download.file(lookupURL,destfile = "rawtext.txt")
      rawtext<-readChar("rawtext.txt", file.info("rawtext.txt")$size)
      pos = regexpr(findme, rawtext)
      newtext<-substring(rawtext,pos+nchar(findme)+11,pos+nchar(findme)+70)
      return(as.numeric(unlist(strsplit(substring(newtext,1,regexpr("]",newtext)-1),","))))
      
      
}

patch_url<-function(my_url){
      ifelse(
            is.na(url_parse(my_url)$scheme), #check if url has something like 'http://'
            my_url<-paste0("http://",my_url), #if not, then add it
            my_url)
}


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
      test_cells <- 5
      my_addresses <- reactiveValues()
      my_addresses$data <- data.table(label = rep("-",test_cells),
                                      street = rep("-",test_cells),
                                      city = rep("-",test_cells),
                                      state = rep("-",test_cells),
                                      zip = rep("-",test_cells),
                                      url = rep("-",test_cells),
                                      icon = rep("http://pluspng.com/img-png/trollface-png-troll-face-png-image-19697-900.png",test_cells),
                                      longitude= rnorm(test_cells) - 122.5, #Hidden Field
                                      latitude = rnorm(test_cells) + 47, #Hidden Field
                                      link = as.character(rep("<a href='http://www.google.com/'>Example Link(Google)</a>",test_cells))) #Hidden Field
      
      mydf <- reactive({
            my_addresses$data
      })
      
      observeEvent(input$add,{
            if (input$street!="-"||input$city!="-"){
                  currLatLong<- getLatLong(data.frame(street = input$street,
                                                      city = input$city,
                                                      state = input$state,
                                                      zip = input$zip))
                  new_row=data.frame(
                        label = input$label,
                        street = input$street,
                        city = input$city,
                        state = input$state,
                        zip = input$zip,
                        url = input$url,
                        icon = "http://pluspng.com/img-png/trollface-png-troll-face-png-image-19697-900.png",
                        longitude=currLatLong[2],
                        latitude=currLatLong[1],
                        link=paste0("<a href='",patch_url(input$url),"'>",input$label,"</a>"))
            }
            my_addresses$data<-rbind(mydf(),new_row)
      })
      
      
      output$map <- renderLeaflet({
            leaflet() %>%
                  addTiles() %>%
                  addMarkers(data = select(mydf(),latitude,longitude), 
                             icon = makeIcon(iconUrl = mydf()$icon,
                                             iconWidth = 40, iconHeight = 40,
                                             iconAnchorX = 15, iconAnchorY = 15),
                             popup = mydf()$link,
                             clusterOptions = markerClusterOptions())
      })
      
      
      output$address_table<-DT::renderDataTable(datatable(select(mydf(),-c(longitude, latitude, link)),  filter="top", selection="multiple", escape=FALSE, 
                                            options = list(sDom  = '<"top">flrt<"bottom">ip')))
      
})

