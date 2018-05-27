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


plot.a <- plot_ly(nutr.data, x = ~LocationAbbr, y = ~Data_Value, type = 'scatter', 
                  mode = 'markers', color = ~Class, colors = "Set1") %>%
  layout(title = '2016 Nutritional Index of Each State <br> (Hover for exact value)',
         yaxis = list(title = "Percentage", showgrid = FALSE),
         xaxis = list(title = "US States", showgrid = FALSE, tickangle = 45),
         showlegend = T)

nutr.2016 <- spread(data = nutr.data, key = Class, value = Data_Value)

colnames(nutr.2016) <- c("State", "StateFull", "Obesity", "PhysicalActivity")

plot.b <- plot_ly(nutr.2016, x = ~Obesity, y = ~PhysicalActivity, 
                  text = ~paste(State, paste("Obesity", Obesity, "%"), 
                                paste("Physical Activity", PhysicalActivity, "%"), sep = "<br />"),
                  hoverinfo = "text", sizes = c(1, 50),
                  type = 'scatter', mode = 'markers',
                  marker = list(opacity = 0.5)) %>%
  layout(title = '2016 Nutritional Index of Each State <br> (Hover for state)',
         xaxis = list(showgrid = FALSE),
         yaxis = list(showgrid = FALSE),
         showlegend = F)

plot.c <- plot_ly(nutr.2016, y = ~State, x = ~Obesity, 
                  type = 'bar', name = 'Obesity', 
                  marker = list(color = 'rgba(246, 78, 139, 0.6)'), orientation = "h") %>%
  add_trace(x = ~PhysicalActivity, name = 'Physical Activity', 
            marker = list(color = 'rgb(26, 118, 255)')) %>%
  layout(xaxis = list(title = "Percentage Value"), 
         yaxis = list(title = "US States"), barmode = 'stack')

pyramid.data <- nutr.data
for (i in 1:nrow(pyramid.data)) {
  if(pyramid.data$Class[i] == "Obesity / Weight Status") {
    pyramid.data$Data_Value[i] <- pyramid.data$Data_Value[i] * -1
  }
}

plot.d <- plot_ly(pyramid.data, y = ~LocationAbbr, x = ~Data_Value, 
                  type = 'bar', orientation = "h", group = ~Class, color = ~Class) %>%
  layout(xaxis = list(title = "Percentage Value"), 
         yaxis = list(title = "US States"), barmode = "group", height = 600, autosize = F, width = 1000)


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
prior.data <- filter(nutr.2016, Obesity >= 32 | PhysicalActivity <= 19)

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
              add_pie(hole = 0.6) %>% 
              layout(title = ~paste("Percentage Distribution of", Class,"in", State, "by", Type, "in", Year),
                     xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                     yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                     showlegend = T)
  
  return(plot.out)
}
