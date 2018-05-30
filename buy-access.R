library(plotly)
library(dplyr)
library(tidyr)
library(plyr)
library(ggplot2)
library(readxl)

# loading the data
stores.data <- read_excel("data/Stores-Accessibility.xlsx")
fm.data <- read_excel("data/Local-Accessibility.xlsx")

# selecting the needed variables
stores.data <- select(stores.data, c("State", "GROCPTH09", "GROCPTH14",
                                     "SUPERCPTH09", "SUPERCPTH14", "CONVSPTH09",
                                     "CONVSPTH14"))
fm.data <- select(fm.data, c("State", "FMRKTPTH09", "FMRKTPTH16"))


# finding average values by state
stores.mean <- aggregate(stores.data[-1], list(stores.data$State), mean)

fm.mean <- aggregate(fm.data[-1], list(fm.data$State), mean, na.rm=T)

# joining the datasets
buy.data <- left_join(stores.mean, fm.mean, by = "Group.1")
colnames(buy.data) <- c("State", "Grocery Stores 2009", "Grocery Stores 2014",
                       "Supercenters 2009", "Supercenters 2014", "Convenience Stores 2009",
                       "Convenience Stores 2014", "Farmers Market 2009", "Farmers Market 2016")

# organizing dataset for both past & recent by state
buy.state <- gather(buy.data, "Type", "Value", -1)

buy.state$Year <- NA
buy.state$Year <- ifelse(endsWith(buy.state$Type, "09"), "Past","Recent")


buy.state$Type <- substr(buy.state$Type, 1, nchar(buy.state$Type)-5)

state.y.plot <- function(State, Time) {
  state.data <- buy.state[which(buy.state$State == State),]
  if (Time != "Past" & Time != "Recent") {
    plot.a <- ggplot(state.data, aes(fill=Year, y=Value, x=Type)) + 
                geom_bar(position="dodge", stat="identity") +
                geom_text(aes(label=round(Value, 3)))
    
  } else {
    state.data <- state.data[which(state.data$Year == Time),]
    col <- 'rgb(50,205,50)'
  
    plot.a <- plot_ly(state.data, x = ~Type, y = ~Value, type = 'bar',
                      marker = list(color = col))%>% 
                layout(title = ~paste("Comparison of Accessibility by Different Types of Stores"),
                      yaxis = list(title = '# Per 1,000 Pop.'), 
                      xaxis = list(title = 'Types of Store'))
  
  }
  plot.out <- plot.a
  return(plot.out)
}


