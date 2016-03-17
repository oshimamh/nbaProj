TeamPlayer = c("team","player")
playTypeList = c("Transition","Isolation","PRBallHandler","PRRollMan","Postup",
                 "Spotup","Handoff","Cut","OffScreen","OffRebound")

getPlayData <-function(TmPlyr, PlayType, offDef){
  URL = paste("http://stats.nba.com/js/data/playtype/",TmPlyr,"_",PlayType,".js", 
              sep = "")
  web_page <- readLines(URL)
  web_page <- web_page[7]
  x1 <- gsub("[\\{\\}\\]]", "", web_page, perl=TRUE)
  x2 <- gsub("[\\[]", "\n", x1, perl=TRUE)
  x3 <- gsub("\"rowSet\":\n", "", x2, perl=TRUE)
  x4 <- gsub(";", ",",x3, perl=TRUE)
  x5 <- strsplit(x4,'"headers"')
  if (offDef == "Offense"){
    x6 <- x5[[1]][2]
    x7 <- gsub(",\"name\":\"Offensive\"","",x6, perl = TRUE)
    playDat<-read.table(textConnection(x7), header=T, sep=",", skip=1, 
                        stringsAsFactors=FALSE)
    playDat <- playDat[,1:ncol(playDat)-1] #strip last column
  } else if (offDef == "Defense" & TmPlyr == "player"){
    x6 <- x5[[1]][3]
    x7 <- gsub(",\"name\":\"Deffensive\"","",x6, perl = TRUE)
    x8 <- paste(x7,",",sep = "")
    playDat<-read.table(textConnection(x8), header=T, sep=",", skip=1, 
                        stringsAsFactors=FALSE)
    playDat <- playDat[,1:ncol(playDat)-1] #strip last column
  } else if (offDef == "Defense" & TmPlyr == "team"){
    x6 <- x5[[1]][3]
    x7 <- gsub(",\"name\":\"Defensive\"","",x6, perl = TRUE)
    x8 <- paste(x7,",",sep = "")
    playDat<-read.table(textConnection(x8), header=T, sep=",", skip=1, 
                        stringsAsFactors=FALSE)
    playDat <- playDat[,1:ncol(playDat)-1] #strip last column
  }
  return(playDat)
}
tmPostOff <- playtypdata2("team","Postup","Offense")
tmPostDef <- playtypdata2("team","Postup","Defense")
plyrPostOff <- playtypdata2("player","Postup","Offense")
plyrPostDef <- playtypdata2("player","Postup","Defense")

getPlayTypeData <- function(TmPlyr, PlayTpe, OffenseDefense){
  URL = paste("http://stats.nba.com/js/data/playtype/",TmPlyr,"_",PlayTpe,".js", 
              sep = "")
  df = fromJSON(readLines(URL)[7])
  if(OffenseDefense == "Offense"){
    off = as.data.frame(
      matrix(
        unlist(df$resultSets[[1]][[3]]),
        ncol=31, byrow = TRUE)
    )
    dat = off
    colnames(dat) = dat$resultSets[[1]][[1]]
    
  }
  else if (OffenseDefense =="Defense"){
    def = data.frame(
      matrix(
        unlist(df$resultSets[[2]][[3]]),
        ncol=31, byrow = TRUE)
    )
    dat = def
    colnames(dat) = dat$resultSets[[2]][[1]]
  }

  #set column names

  return(dat)
}
f = getPlayTypeData("team", "Spotup", "Defense")
