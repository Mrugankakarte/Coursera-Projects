# ui.R

library(shinythemes)

fluidPage(
      
      theme = shinytheme("slate"),
      
      navbarPage(title = "Word Prediction!",
                tabPanel("Home",
                         h4("This application was developed for Capstone Project of Data Science Specialization offered by John Hopkins University."),
                         h4("*Please read the ReadME section under the tab 'More..")
                         
                ), # home tab
                
                tabPanel("Prediction",
                     sidebarLayout(
                                   sidebarPanel(
                                         wellPanel(
                                               textInput("input_vec", label = "Enter text :", value = "")
                                         )
                                                ),     #edit sidebarpanel
                                   mainPanel(
                                         h3("Predictions"),
                                         dataTableOutput("table")
                                         )   #edit mainpanel
                                   )    # sidebarlayout
                     ), #prediction tab
                
                navbarMenu("More...",
                         tabPanel("ReadME",
                                  includeMarkdown("ReadME.Rmd")
                                  )
                          ) #more tab
      ) #navbarpage
) # fluid page