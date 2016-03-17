TeamPlayer = c("team","player")
playTypeList = c("Transition","Isolation","PRBallHandler","PRRollMan","Postup",
                 "Spotup","Handoff","Cut","OffScreen","OffRebound")

getPlayData <- function(PlayType){
  URL = paste("http://stats.nba.com/js/data/playtype/player_",PlayType,".js", 
              sep = "")
  web_page <- readLines(URL)
  web_page <- web_page[7]
  x1 <- gsub("[\\{\\}\\]]", "", web_page, perl=TRUE)
  x2 <- gsub("[\\[]", "\n", x1, perl=TRUE)
  x3 <- gsub("\"rowSet\":\n", "", x2, perl=TRUE)
  x4 <- gsub(";", ",",x3, perl=TRUE)
  x5 <- gsub(",\"name\":\"Offensive\"","",x4, perl = TRUE)
  x6 <- paste(x5,",",sep = "")
  playDat<-read.table(textConnection(x6), header=T, sep=",", skip=2, 
                  stringsAsFactors=FALSE)
  playDat <- playDat[,1:ncol(playDat)-1] #strip last column
  return(playDat)
  }