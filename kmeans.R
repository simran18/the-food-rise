######
# KMEANS ANALYSIS 
######

library(dplyr)
library(cluster)    # clustering algorithms
library(factoextra) # for viz
library(ClustOfVar)
library(PerformanceAnalytics)

detach(package:plyr)

#Dataframes for kmeans from other files
exp_data <- expenditure_changed %>%
  select(States,food_and_beverages_2016)

kmeans_acc2<- average.data%>%
  select(State,PCT_LACCESS_POP15)%>%
  group_by(State)%>%
  summarize(macc = mean(PCT_LACCESS_POP15,na.rm = TRUE))

kmeans_acc <- buy.data%>%
  select(State,`Farmers Market 2016`,`Convenience Stores 2014`,`Supercenters 2014`,`Grocery Stores 2014`)


#wrangling data from other files
tmpjoin <- left_join(nutr.2016,exp_data,by = c("StateFull" = "States"))
tmpjoin2 <- left_join(kmeans_acc2,kmeans_acc,by = "State")
finalcombined <- left_join(tmpjoin,tmpjoin2,by = "State")


#reproducability
set.seed(123)

df <- finalcombined%>%
  select(-State)
rownames(df) <- df[,1]
df <- df[,-1]
df <- scale(df) #scaling values

colnames(df) <- c("Obesity","Physical Inactivity","Food and Beverages Cost","Pop Low Acc","Farmers Market Acc","Convenience Stores Acc","Supercenters Acc","Grocery Stores Acc")

set.seed(123)

#Euclidean Distance Viz

tree <- hclustvar(df)
distance <- get_dist(df)
corrdf <- df

#removing Obesity from our kmeans result
df <- df[,-1]

corr_chart <- function(){
  chart.Correlation(corrdf, histogram=TRUE, pch=19)
}

variables_cluster <- function(){
  plot(tree)
}



states_heatmap <- function(){
  fviz_dist(distance, gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))
}

interactive_kmeans <- function(kval){
  kmresult <- kmeans(df, centers = kval, nstart = 25)
  fviz_cluster(kmresult, data = df)
}

diff_k <- function(meth){
  #wss or silhouette
  fviz_nbclust(df, kmeans, method = meth)
  
}


# Print the result

# OUR FINAL ANALYSIS RESULT
final_kmeans <- function(){
  final <- kmeans(df, 3, nstart = 25)
  fviz_cluster(final, data = df)
}
