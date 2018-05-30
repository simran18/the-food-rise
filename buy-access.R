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
                       "Convenience Stores 2014", "Farmers Market 2009", "Farmers Market 2014")

# selecting data for 2009
buy.old <- select(buy.data, ends_with("09"))
buy.old$State <- buy.data$State
buy.old <- gather(buy.old, "Type", "Value", -State)

# selecting data for 2016
buy.new <- select(buy.data, -ends_with("09"))
buy.new <- gather(buy.new, "Type", "Value", -1)


state.y.plot <- function(State, Year) {
  if (Year == "Past") {
    state.data <- buy.old[which(buy.old$State == State),]
    col <- 'rgb(50,205,50)'
    
  } else {
    state.data <- buy.new[which(buy.new$State == State),]
    col <- 'rgb(158,202,225)'
  }
  
  plot.out <- plot_ly(state.data, x = ~Type, y = ~Value, type = 'bar',
                      marker = list(color = col))%>% 
              layout(title = ~paste("Comparison of Accessibility by Different Types of Stores"),
                     yaxis = list(title = '# Per 1,000 Pop.'), 
                     xaxis = list(title = 'Types of Store'))
  
  
  return(plot.out)
}


