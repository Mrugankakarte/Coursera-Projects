# server.R

source("prediction.R")

function(input, output){
      
      pred <- reactive({
            input_vec <- input$input_vec
            pred <- prediction(input_vec)
            
      })

      output$table <- renderDataTable(pred(),
                                      options = list(paging = F,
                                                     scrollY = "200px",
                                                     scrollCollapse = T
                                                     )
                                      
                                      )
            
}