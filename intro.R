library(plotly)
library(dplyr)
library(tidyr)
library(plyr)
library(ggplot2)

insec.data <- read_excel("data/Food-Insecurity.xlsx")
insec.data <- select(insec.data, c("State", "FOODINSEC_00_02", "FOODINSEC_07_09","FOODINSEC_10_12"))
insec.data<- aggregate(insec.data[-1], list(insec.data$State), mean, na.rm = T)
colnames(insec.data) <- c("State", "2000-2002", "2007-2009", "2010-2012")

plot.insec <-  plot_ly(insec.data, x = ~State, y = ~insec.data$`2010-2012`, 
                       type = 'bar', marker = list(color = 'rgb(255, 0, 0'))%>% 
              layout(title = "Food Insecurity in the US from 2010 to 2012",
                     yaxis = list(title = 'Household % average'), 
                     xaxis = list(title = 'US States'))
