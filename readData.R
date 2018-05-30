#####
# THIS FILE READS IN THE DATA
# SOURCE THIS FILE INTO ALL YOUR OTHER ANALYSIS FILES TO READ DATA
#####

library(readxl)
library(dplyr)
library(tidyr)

#EXPENDITURE

# Region-State level data for
# Percent change in expenditure in each category from 2015-2016
exp_data <- read_excel("./data/expenditure-data.xlsx",sheet = "Table 2 pg 2")
exp_data <- na.omit(exp_data)
exp_data<- exp_data%>%
  select(-X__8)
colnames(exp_data) <- c("Loc",'Housing & Utilities','Healthcare','Transportation','Recreation','Food Services','Financial Services','Other Services')


#PHYSICAL ACTIVITY_OBESITY

activity <- read.csv("./data/Physical_Activity_Obesity.csv")

#state level data from 2011 to 2016 for 
#"Percent of adults aged 18 years and older who have obesity"
state_overall_obesity <- activity%>%
  filter(LocationAbbr != "US",Class == "Obesity / Weight Status",StratificationID1 == "OVERALL",Question == "Percent of adults aged 18 years and older who have obesity")%>%
  select(YearEnd,LocationAbbr,LocationDesc,Data_Value,GeoLocation)%>%
  spread(YearEnd,Data_Value)

#State Level Physical Activity Data from 2011,2013 and 2015
#"Percent of adults who achieve at least 150 minutes a week of moderate-intensity aerobic physical activity or 75 minutes a week of vigorous-intensity aerobic physical activity and engage in muscle-strengthening activities on 2 or more days a week"

state_overall_activity <- activity%>%
  filter(LocationAbbr != "US",Class == "Physical Activity",StratificationID1 == "OVERALL",Question == "Percent of adults who achieve at least 150 minutes a week of moderate-intensity aerobic physical activity or 75 minutes a week of vigorous-intensity aerobic physical activity and engage in muscle-strengthening activities on 2 or more days a week")%>%
  select(YearEnd,LocationAbbr,LocationDesc,Data_Value,GeoLocation)%>%
  spread(YearEnd,Data_Value)

#ACCESIBILITY

access_data <- read_excel("./data/Accessibility.xls",sheet = "ACCESS")
access_data2 <- read_excel("./data/Accessibility.xls",sheet = "LOCAL")

#State-County Level accessibility data for
#Percentage of Population with Low Access to Stores
county_low_access <- access_data%>%
  select(FIPS,State,County,PCT_LACCESS_POP10,PCT_LACCESS_POP15)
colnames(county_low_access) <- c("FIPS","State","County","2010","2015") 

#State-County Level accesibility data for
#Number of Farmers Markets per 100 pop
county_farmer_access <- access_data2%>%
  select(FIPS,State,County,FMRKTPTH09,FMRKTPTH16)
colnames(county_farmer_access)<- c("FIPS","State","County","2009","2016")

# DATA PREP FOR K MEANS

#Access data prep
tmpfarmaccess <- county_farmer_access%>%
  group_by(State)%>%
  summarize(farmacc = mean(`2016`, na.rm = T))
tmplowaccess <- county_low_access%>%
  group_by(State)%>%
  summarize(lowacc = mean(`2015`, na.rm = T))

finalaccess <- left_join(tmpfarmaccess,tmplowaccess,by='State')

#Activity Data prep
tmpactivity <- state_overall_activity%>%
  select(LocationAbbr,`2015`)
colnames(tmpactivity) <- c("LocationAbbr",'activity')

tmpobesity <- state_overall_obesity%>%
  select(LocationAbbr,LocationDesc,`2016`)
colnames(tmpobesity) <- c("LocationAbbr","LocationDesc",'obesityval')

finalactivity <- left_join(tmpobesity,tmpactivity,by = "LocationAbbr")

#Exp Data Prep
tmpexp <- exp_data%>%select(c('Loc','Food Services'))

#combining all datasets together 
finalcombined <- left_join(finalactivity,tmpexp,by = c('LocationDesc' = 'Loc'))%>%
  na.omit()
finalcombined <- left_join(finalcombined,finalaccess,by = c('LocationAbbr' = 'State'))%>%
  na.omit()
finalcombined$`Food Services` <- as.numeric(finalcombined$`Food Services`)

#Final Number of States in Analysis is 39
#STATES EXCLUDED DUE TO MISSING DATA - 
#Georgia, Illinois, Indiana, Kentucky, Michigan, Mississippi, North Carolina, South Dakota, Tennessee, Texas, Virginia, Wisconsin
