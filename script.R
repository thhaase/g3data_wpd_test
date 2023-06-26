library(httr)
library(XML)
library(tidyverse)
library(scales)


### ### ### download table ### ### ###

# GET url to use readHTMLTable later
url <- "https://de.wikipedia.org/wiki/Wikipedia:Spendenstatistik"
r <- GET(url)

# save HTML Table as dataframe
tab <- readHTMLTable(doc = content(r, "text"))
df <- as.data.frame(tab[1])

# first row as variablenames
colnames(df) <- unlist(df[1,])
df <- df[-1,]

# delete QUELLE cause its useless information
df <- df[,-2]

# clean data (character to numeric)
df$Jahr <- as.numeric(trimws(df$Jahr, whitespace = "/.*"))
df$Gesamteinnahmen <- as.numeric(gsub("\\D", "", df$Gesamteinnahmen))
df$Gesamtausgaben <- as.numeric(gsub("\\D", "", df$Gesamtausgaben))
df$`Anstieg Nettovermögen` <- as.numeric(gsub("\\D", "", df$`Anstieg Nettovermögen`))
df$`Nettovermögen zum Jahresende` <- as.numeric(gsub("\\D", "", df$`Nettovermögen zum Jahresende`))


### ### ### plot table ### ### ###

# Create line plot using ggplot2
ggplot(df, aes(x = Jahr, y = Gesamteinnahmen)) +
  geom_line() + 
  scale_y_continuous(labels = comma)

# folgender plot nur aus interesse 
ggplot(df, aes(x = Gesamteinnahmen, y = Gesamtausgaben)) +
  geom_line() + 
  scale_y_continuous(limits = c(0,100000000), labels = comma) +
  scale_x_continuous(limits = c(0,100000000), labels = comma)
  

### ### Test ### ###
### Webplotdigitizer ###
# https://apps.automeris.io/wpd/index.de_DE.html

# load csv and rename variables
wpd <- read.csv("./webplotdigitizer.csv", header = FALSE, sep=";")
colnames(wpd) <- c("Jahr", "Gesamteinnahmen")

# make variables numeric and round
wpd$Jahr <- round(as.numeric(gsub(",", ".", wpd$Jahr)))
wpd$Gesamteinnahmen <- round(as.numeric(gsub(",", ".", wpd$Gesamteinnahmen)))

### comparison datagrame ###

comp <- data.frame(df$Jahr, wpd$Jahr, df$Gesamteinnahmen, wpd$Gesamteinnahmen)

# prozentuale abweichung vom originalwert berechnen
comp$diff <- abs(comp$wpd.Gesamteinnahmen - comp$df.Gesamteinnahmen)/comp$df.Gesamteinnahmen

mean(comp$diff)
# mean = 0.179
median(comp$diff)
# median = 0.0075




### ### ### g3data ### ### ###
g3 <- read.table("g3data.dat")

colnames(g3) <- c("Gesamteinnahmen", "Jahr")
g3$Jahr <- round(as.numeric(gsub(",", ".", g3$Jahr)))
g3$Gesamteinnahmen <- round(as.numeric(gsub(",", ".", g3$Gesamteinnahmen)))

g3$Gesamteinnahmen <- rev(g3$Gesamteinnahmen)
g3$Jahr <- rev(g3$Jahr) 

g3comp <- data.frame(df$Jahr, g3$Jahr, df$Gesamteinnahmen, g3$Gesamteinnahmen)
g3comp$diff <- abs(g3comp$g3.Gesamteinnahmen - g3comp$df.Gesamteinnahmen)/g3comp$df.Gesamteinnahmen

mean(g3comp$diff)
median(g3comp$diff)
