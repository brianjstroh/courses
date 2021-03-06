Map Log Presentation
========================================================
author: Brian Stroh
date: November 7th, 2018
autosize: true

The application can be found here: <https://bstroh.shinyapps.io/Map_Log/>
<!-- ![Map Log Screenshot](maplog.png) -->


About the Map Log Tool
========================================================

The Map Log Tool utilizes Google Map's geocoding functionality.
Information on geocoding can be found here: <https://en.wikipedia.org/wiki/Geocoding>

The user can submit address(es) through the application and a new marker at the longitude/latitude coordinates of the submitted address(es) will pop up on the Leaflet map.  
Each marker has an associated link which allows the user to connect their addresses to an external website.

This Map Log Tool could be particularly useful for travel bloggers.  
After having explored a new place and written a blog post about it, the blogger could use this tool to mark all addresses that have been blogged about in one central location and provide a link to each corresponding blog post.


Geocoding Demo
========================================================
The following (partial) function is the foundation for the Map Log Tool's geocoding utility:
<font size="8">

```r
getLatLong<- function(address){
            findme<-as.character(paste(address$street,
                                       address$city,
                                       paste(address$state,
                                             paste0(address$zip,"\",null,"),
                                             sep=" "),
                                       sep=", "))
            address$street<-gsub(" ","+",address$street)
            lookupURL<-paste0("https://www.google.com/maps/place/",
                              address$street,
                              ",+",address$city,
                              ",+",address$state,
                              "+",address$zip,"/")
      download.file(lookupURL,destfile = "rawtext.txt")
      rawtext<-readChar("rawtext.txt", file.info("rawtext.txt")$size)
      pos = regexpr(findme, rawtext)
      newtext<-substring(rawtext,pos+nchar(findme)+11,pos+nchar(findme)+70)
      return(as.numeric(unlist(strsplit(substring(newtext,1,regexpr("]",newtext)-1),","))))
}
street = "416 Sid Snyder Ave SW"; city = "Olympia"; state = "WA"; zip = "98504"
address = data.frame(street=street,city=city,state=state,zip=zip)
getLatLong(address)
```

```
[1]   47.03594 -122.90445
```
</font>

Map Log Table
========================================================

![Map Table Screenshot](maptable.png)

All logged addresses are stored in the 'Logged Location Table' tab of the app.
The user can easily search for keyword(s) to filter down the table's results and just focus on specific marked locations.

Map Log Documentation
========================================================

![Map Log Screenshot](maplogdoc.png)

All documentation necessary to get started with the Map Log Tool is included on the 'Documentation' tab of the application.
