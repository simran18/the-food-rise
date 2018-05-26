library(shiny)

shinyServer(function(input, output) {
  
  output$image <- renderImage({
    return(list(
        src = "venn_diag.png",
        contentType = "image/png",
        alt = "Venn"
      ))
    }, deleteFile = FALSE)
})
