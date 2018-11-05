
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


#-----------------------------------------------------------------------------------------------------------
#----------------------------------------------TESTING------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------
# 
# street = "3213 SE 6th St"
# city = "Renton"
# state = "WA"
# zip = "98058"
# address = data.frame(street=street,city=city,state=state,zip=zip)
# 
# street2 = "12227 Pasha Lane"
# city2 = "Orlando"
# state2 = "FL"
# zip2 = "32827"
# address2 = data.frame(street=street2,city=city2,state=state2,zip=zip2)
# 
# street3 = "2890 Chance Ct"
# city3 = "Huntingtown"
# state3 = "MD"
# zip3 = "20639"
# address3 = data.frame(street=street3,city=city3,state=state3,zip=zip3)
# 
# street4 = "15338 NE 9th Pl"
# city4 = "Bellevue"
# state4 = "WA"
# zip4 = "98007"
# address4 = data.frame(street=street4,city=city4,state=state4,zip=zip4)
# 
# street5 = "1301 5th Ave"
# city5 = "Seattle"
# state5 = "WA"
# zip5 = "-"
# address5 = data.frame(street=street5,city=city5,state=state5,zip=zip5)
# 
# street6 = "-"
# city6 = "Paradise"
# state6 = "WA"
# zip6 = "-"
# address6 = data.frame(street=street6,city=city6,state=state6,zip=zip6)
# 
# 
# street7 = "-"
# city7 = "Seattle"
# state7 = "-"
# zip7 = "-"
# address7 = data.frame(street=street7,city=city7,state=state7,zip=zip7)
# 
# getLatLong(address)
# getLatLong(address2)
# getLatLong(address3)
# getLatLong(address4)
# getLatLong(address5)
# getLatLong(address6)
# getLatLong(address7)
