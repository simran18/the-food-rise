######
# KMEANS ANALYSIS 
######

# load data 
source('readData.R')

library(dplyr)
library(cluster)    # clustering algorithms
library(factoextra) # for viz

#reproducability
set.seed(123)

df <- finalcombined%>%
  select(-LocationAbbr)
rownames(df) <- df[,1]
df <- df[,-1]
df <- scale(df) #scaling values

#Euclidean Distance Viz

distance <- get_dist(df)

states_heatmap <- function(){
  fviz_dist(distance, gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))
}

interactive_kmeans <- function(kval){
  kmresult <- kmeans(df, centers = kval, nstart = 25)
  fviz_cluster(kmresult, data = df)
}

diff_k <- function(){
  fviz_nbclust(df, kmeans, method = "wss")
  
  #NEED TO DECIDE IF/NOT TO INCLUDE
  #fviz_nbclust(df, kmeans, method = "silhouette")
  #gap_stat <- clusGap(df, FUN = kmeans, nstart = 25,
   #                   K.max = 10, B = 50)
  #fviz_gap_stat(gap_stat)

}


# Print the result

# OUR FINAL ANALYSIS RESULT
final_kmeans <- function(){
  final <- kmeans(df, 2, nstart = 25)
  fviz_cluster(final, data = df)
}
