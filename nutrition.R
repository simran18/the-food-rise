library(plotly)
library(dplyr)
library(tidyr)
library(plyr)
library(ggplot2)
library(readxl)
obes.pa.data <- read.csv("data/Physical_Activity_Obesity.csv", stringsAsFactors = F)
obes.pa.data <- obes.pa.data[which(obes.pa.data$Class != "Fruits and Vegetables"),]

# bubble plot with size = obesity and color = physical activity 
nutr.data <- filter(obes.pa.data, YearStart == 2016 & 
                                LocationDesc != "National" & Total == "Total" & QuestionID != "Q037") %>%
             select(c("LocationAbbr", "LocationDesc", "Class", "Data_Value"))  

nutr.2016 <- spread(data = nutr.data, key = Class, value = Data_Value)

colnames(nutr.2016) <- c("State", "StateFull", "Obesity", "PhysicalActivity")

# compatrison between states
plot.c <- plot_ly(nutr.2016, y = ~State, x = ~Obesity, 
                  type = 'bar', name = 'Obesity', 
                  marker = list(color = 'rgba(246, 78, 139, 0.6)'), orientation = "h") %>%
  add_trace(x = ~PhysicalActivity, name = 'Physical Activity', 
            marker = list(color = 'rgb(26, 118, 255)')) %>%
  layout(xaxis = list(title = "Percentage Value"), 
         yaxis = list(title = "US States"), barmode = 'stack')


#put on report - fix labels 
plot.e <- ggplot(nutr.data, aes(x = LocationDesc, y = Data_Value, fill = Class)) + 
  geom_bar(subset = .(Class == "Obesity / Weight Status"), stat = "identity") + 
  geom_bar(subset = .(Class == "Physical Activity"), stat = "identity") + 
  scale_y_continuous(breaks = seq(-45, 45, 5)) +
  coord_flip() + 
  scale_fill_brewer(palette = "Set1") + 
  theme_bw()

# conduct analysis about states
# highest obesity
high.obes <- nutr.2016[which.max(nutr.2016$Obesity),]$StateFull

# lowest obesity
low.obes <- nutr.2016[which.min(nutr.2016$Obesity),]$StateFull

# highest physical activity
high.pa <- nutr.2016[which.max(nutr.2016$PhysicalActivity),]$StateFull

# lowest physical activity
low.pa <- nutr.2016[which.min(nutr.2016$PhysicalActivity),]$StateFull

# average pa 
mean.pa <- mean(nutr.2016$PhysicalActivity)

# average pa 
mean.ob <- mean(nutr.2016$Obesity) 

# priority states (check values of unhealthy)
prior.data <- filter(nutr.2016, Obesity >= 34 | PhysicalActivity <= 17)

# indepth analysis - select function - only for priority or all?
# show trend over the years from 2011 - 2016 by selecting state

yearly.data <- filter(obes.pa.data, Total == "Total") %>% 
               filter(QuestionID == "Q036" | QuestionID == "Q047") %>% 
               select(c("YearStart", "LocationDesc", "Class", "Data_Value"))  
state.plot <- function(State) {
  state.data <- yearly.data[which(yearly.data$LocationDesc == State),]
  plot.out <- plot_ly(state.data, x = ~YearStart, y = ~Data_Value, color = ~Class, 
                      type = 'scatter', mode = 'lines+markers') %>% 
              layout(title = ~paste("Trend of Physical Activity & Obesity in", State, "Over The Years"),
                     xaxis = list(title = "Years"),
                     yaxis = list(title = 'Percentage Value'))

  return(plot.out)
}

# show distribution of nutritional value by selecting state, year, type and social determinant
obes.pa.depth <- filter(obes.pa.data, QuestionID == "Q036" | QuestionID == "Q047") %>% 
                select(c("YearStart", "LocationDesc", "Class", "Data_Value", 
                         "StratificationCategory1", "Stratification1")) 
indepth.plot <- function(State, Class, Year, Type) {
  indepth.data <- filter(obes.pa.depth, LocationDesc == State & YearStart == Year & 
                         Class == Class & StratificationCategory1 == Type) %>%  
                  select("Stratification1", "Data_Value") 
  plot.out <- plot_ly(indepth.data, labels = ~Stratification1, values = ~Data_Value, type = 'pie') %>% 
              layout(title = ~paste("Percentage Distribution of", Class,"in", State, "by", Type, "in", Year),
                     xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                     yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                     showlegend = T)
  
  return(plot.out)
}
