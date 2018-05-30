library(shiny)

shinyServer(function(input, output, session) {
  
  ##############
  #INTRODUCTION#
  ##############
  output$plot.insec <- renderPlotly({
    plot.insec
  })
  
  output$img <- renderImage({
    
    return(list(src = "food_security.png",
      contentType = "image/png",
      width = 500,
      alt = "Food security"
    ))
  }, deleteFile = FALSE)
  
  output$img2 <- renderImage({
    
    return(list(src = "data-overview.png",
                contentType = "image/png",
                width = 1000,
                height = 350,
                alt = "Food security"
    ))
  }, deleteFile = FALSE)
  
  #############
  #EXPENDITURE#
  #############
  
  output$totalExp <- renderPlotly({
    total_exp(input$expYear)
  })
  
  output$perCapitaBubble <- renderPlotly({
    return(bubble_p)
  })
  
  ###########
  #NUTRITION#
  ###########
  
  output$nationalTrend <- renderPlotly({
    state.plot("National")
  })
  
  output$plot.b <- renderPlotly({
    plot.b
  })
  
  output$plot.ob <- renderPlotly({
    plot.ob
  })
  
  output$plot.pa <- renderPlotly({
    plot.pa
  })
  
  output$state.plot <- renderPlotly({
    state.plot(input$state.list)
  })
  
  output$analysisPlot <- renderPlotly({
    indepth.plot(input$plot.state,input$plot.class,input$plot.year,input$plot.type)
  })
  
  ########
  #ACCESS#
  ########
  output$accessPlot <- renderPlotly({
    access <- selected(input$Population, input$Year)
    #renames second column name to allow aggregate to work
    colnames(access)[2] <- "Population-Year"
    #aggregate based on mean
    avg <- aggregate(access$`Population-Year`, by = list(access$State), FUN = mean, na.rm = TRUE)
    colnames(avg)[1] <- "State"
    #join state names with abbreviations to show the hover on graph
    avg <- left_join(avg, states, by = "State")
    p_access <- graph(avg)
    p_access$elementId <- NULL
    return(p_access)
  })
  
 output$buyAccessPlot <- renderPlotly({
    state.y.plot(input$b.plot.state, input$b.plot.year)
 })
  
 ########
 #K means#
 ########
 
 # K means 
 output$image <- renderImage({
   return(list(
     src = "venn.png",
     contentType = "image/png",
     alt = "Venn"
   ))
 }, deleteFile = FALSE)
 
 output$heatmap <- renderPlot({
   states_heatmap()
 })
 
 output$corr <- renderPlot({
   corr_chart()
 })
 
 output$varclust <- renderPlot({
   variables_cluster()
 })
 
 output$diffk <- renderPlot({
   diff_k(input$meth)
 })
 
 output$km <- renderPlot({
   interactive_kmeans(input$k)
 })
 
 output$final_result <- renderPlot({
   final_kmeans()
 })


##########
# Report #
##########
output$expend1 <- renderImage({
  
  return(list(src = "expend1.png",
              contentType = "image/png",
              width = 750,
              alt = "Expenditure"
  ))
}, deleteFile = FALSE)

output$nutrition1 <- renderImage({
  
  return(list(src = "nutrition1.png",
              contentType = "image/png",
              width = 750,
              alt = "Nutrition Overview 1"
  ))
}, deleteFile = FALSE)

output$nutrition2 <- renderImage({
  
  return(list(src = "nutrition2.png",
              contentType = "image/png",
              width = 500,
              alt = "Nutrition Overview 2"
  ))
}, deleteFile = FALSE)

output$access1 <- renderImage({
  
  return(list(src = "access1.png",
              contentType = "image/png",
              width = 500,
              alt = "Accessibility Overview"
  ))
}, deleteFile = FALSE)

output$CT <- renderImage({
  
  return(list(src = "CT.png",
              contentType = "image/png",
              width = 750,
              alt = "Conneticut"
  ))
}, deleteFile = FALSE)

output$MA <- renderImage({
  
  return(list(src = "MA.png",
              contentType = "image/png",
              width = 750,
              alt = "MA"
  ))
}, deleteFile = FALSE)

output$NJ <- renderImage({
  
  return(list(src = "NJ.png",
              contentType = "image/png",
              width = 750,
              alt = "NJ"
  ))
}, deleteFile = FALSE)

})