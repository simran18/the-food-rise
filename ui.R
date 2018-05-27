library(shiny)
library(plotly)




shinyUI(fluidPage(
  theme = shinytheme("yeti"),
  navbarPage("INF0 498",
    tabPanel("Introduction",
      titlePanel("Geographic Location and Food Security"),
      imageOutput("image", height = 100)
    ),
    mainPanel(
      #TO BE FILLED WITH DATA INTRODUCTION
      #imageOutput("image", height = 100)
    ),
    tabPanel("Affordability"
      # TAB FOR AFFORDABILITY
    ),
    tabPanel("Nutrition"
      # TAB FOR NUTRITION
    ),
    tabPanel("Accessibility"
      # TAB FOR ACCESSIBILITY
    ),
    tabPanel("Report",
      # TAB FOR FINAL REPORT
      
      titlePanel("Final Report"),
            
      
      plotOutput("heatmap",width = "80%",height = 600),
      
      titlePanel("K Means Clustering"),
      h4("To Add"),
      br(),
      sidebarLayout(
        sidebarPanel(
          sliderInput("k", "K Value", min = 2, max = 15,value = 2,step = 1),
          plotOutput('diffk')
        )  , mainPanel(
          h2("K Means Clustering"),
          plotOutput("km"),
          h5(".")
        )
      ),
      titlePanel("Conclusion"),
      p("Talk about how we decided this k"),
      plotOutput('final_result',width = '80%',height = 500)
    )
  ))
)
