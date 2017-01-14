library(ggplot2)
library(plotly)
library(ggfortify)
library(fpp)

shinyUI(navbarPage("Forecasting Application!",
                   tabPanel("Home",
                            sidebarLayout(position = "right",
                                          sidebarPanel(
                                            h3("Data file"),
                                            tableOutput('demo'),
                                            h5("...so on")
                                          ),
                                          mainPanel(
                                            h1("FORECASTING APP"),
                                            h4("Please ensure before uploading that your data is of same format as shown."),
                                            h5("Please read the README section in the last tab before using the application.")
                                          )
                            )
                   ),
                   tabPanel("Data",
                             mainPanel(
                              h4( span("Please upload your data file", style = "color:red")),
                              fileInput('file1', 'Choose CSV File',
                                        accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')), 
                              tableOutput('contents'))
                        
                   ),
                   tabPanel("Plot",
                              mainPanel("Graph",plotlyOutput("plot")
                              )
                   ),
                   navbarMenu("Forecast",
                            tabPanel("Time series decomposition",
                                     h3("Time Series Decomposition"),
                                     h5("The decomposition of time series is a statistical method that deconstructs a time series into several components, each representing one of the underlying categories of patterns"),
                                     h5("The Trend Component at time t, that reflects the long-term progression of the series (secular variation). A trend exists when there is an increasing or decreasing direction in the data. The trend component does not have to be linear."),
                                     h5("The Cyclical Component at time t, that describes repeated but non-periodic fluctuations. The duration of these fluctuations is usually of at least two years."),
                                     h5("The Seasonal Component at time t, reflecting seasonality (seasonal variation). A seasonal pattern exists when a time series is influenced by seasonal factors. Seasonality is always of a fixed and known period (e.g., the quarter of the year, the month, or day of the week)."),
                                     h5("The Irregular Component at time t, that describes random, irregular influences. It represents the residuals or remainder of the time series after the other components have been removed."),
                                     mainPanel("", plotlyOutput('pTSD'))
                                                
                                    ),
                            tabPanel("Simple Exponential smoothing",
                                     h3("Simple Exponential Smoothing"),
                                     h5("This is a very popular scheme to produce a smoothed Time Series. Whereas in Single Moving Averages the past observations are weighted equally, Exponential Smoothing assigns exponentially decreasing weights as the observation get older."),
                                     h5("In other words, recent observations are given relatively more weight in forecasting than the older observations."),
                                     mainPanel("",plotlyOutput('pSE'))
                                                  
                                     ),
                            tabPanel("Holt's Linear trend method",
                                     h3("Holt's Linear Trend method"),
                                     h5("Holt (1957) extended simple exponential smoothing to allow forecasting of data with a trend. This method involves a forecast equation and two smoothing equations (one for the level and one for the trend)"),
                                     mainPanel("",plotlyOutput('pHL'))
                               
                                           ),
                            tabPanel("Holt Winters seasonal method",
                                     h3("Holt Winters seasonal method"),
                                     h5("Holt (1957) and Winters (1960) extended Holt's method to capture seasonality. The Holt-Winters seasonal method comprises the forecast equation and three smoothing equations - one for the level, one for trend, and one for the seasonal component, with smoothing parameters alpha, beta and gamma"),
                                     mainPanel("",plotlyOutput('pHW')),
                                     mainPanel("",plotlyOutput('pHWM'))
                                                  
                                       ),
                            tabPanel("ETS Model",
                                     h3("ETS Model (Error Trend Seasonal)"),
                                     h5("The ETS framework encompasses the standard ES models (e.g., Holt and Holt-Winters additive and multiplicative methods)"),
                                     h5("Automatically chooses a model by default using the AIC, AICc or BIC. Can handle any combination of trend, seasonality and damping. Produces prediction intervals for every model"),
                                     h5("All exponential smoothing methods can be written using analogous state space equations."),
                                     h5("Minimizing the AIC gives the best model for prediction."),
                                     h5("AIC does not have much meaning by itself. Only useful in comparison to AIC value for another model fitted to same data set. Consider several models with AIC values close to the minimum. A difference in AIC values of 2 or less is not regarded as substantial and you may choose the simpler but non-optimal model. AIC can be negative."),
                                     
                                     mainPanel("",plotlyOutput('pets'))
                                                   
                                                  
                                    ),
                            tabPanel("ARIMA Model",
                                     h3("ARIMA Model (Auto Regression Integrated with Moving Averages)"),
                                     h5(" An autoregressive integrated moving average (ARIMA) model is a generalization of an autoregressive moving average (ARMA) model. These models are fitted to time series data either to better understand the data or to predict future points in the series (forecasting). They are applied in some cases where data show evidence of non-stationarity, where an initial differencing step (corresponding to the integrated part of the model) can be applied to reduce the non-stationarity."),
                                     h5("Non-seasonal ARIMA models are generally denoted ARIMA(p,d,q) where parameters p, d, and q are non-negative integers."),
                                     h5("p is the order of the autoregressive model"),
                                     h5("d is the degree of differencing"),
                                     h5("q is the order of the moving-average model"),
                                     h5("Seasonal ARIMA models are usually denoted ARIMA(p,d,q)(P,D,Q)m, where m refers to the number of periods in each season, and the uppercase P,D,Q refer to the autoregressive, differencing, and moving average terms for the seasonal part of the ARIMA model."),
                                     mainPanel("",plotlyOutput('pa'))
                                    )
                            ),
                   tabPanel("Error Table",
                            sidebarLayout(position = "right",
                                          sidebarPanel( 
                                                h4("Please wait for tables to load...")
                                                ),
                                          
                                          mainPanel("",
                                                    h3("Time series Decomposition"),
                                                    tableOutput('errtableTSD'),
                                                    h3("Simple Exponential smoothing"),
                                                    tableOutput('errtableSE'),
                                                    h3("Holt's Linear Trend Method"),
                                                    tableOutput("errtableHL"),
                                                    h3("Holt Winters Seasonal Method"),
                                                    tableOutput('errtableHW'),
                                                    h3(" Auto ETS"),
                                                    tableOutput('errtableETS'),
                                                    h3("Auto ARIMA (Short)"),
                                                    tableOutput('errtableA'),
                                                    h3("ETS Models"),
                                                    tableOutput('Etstable'))
                            )

                            ),
                   navbarMenu("ETS Models",
                              tabPanel("ANN",
                                       mainPanel("ETS ANN",plotlyOutput('petsANN'))
                                       
                                       ),
                              tabPanel("AAN",
                                       mainPanel("ETS AAN",plotlyOutput('petsAAN'))
                                       
                                       ),
                              tabPanel("AAA",
                                       mainPanel("ETS AAA",plotlyOutput('petsAAA'))
                                       
                                       ),
                              tabPanel("ANA",
                                       mainPanel("ETS ANA",plotlyOutput('petsANA'))
                                       
                                       ),
                              tabPanel("MNN",
                                       mainPanel("ETS MNN",plotlyOutput('petsMNN'))
                                       
                                       ),
                              tabPanel("MNA",
                                       mainPanel("ETS MNA",plotlyOutput('petsMNA'))
                                       
                                       ),
                              tabPanel("MNM",
                                       mainPanel("ETS MNM",plotlyOutput('petsMNM'))
                                       
                                       ),
                              tabPanel("MAN",
                                       mainPanel("ETS MAN",plotlyOutput('petsMAN'))
                                       
                                       ),
                              tabPanel("MAA",
                                       mainPanel("ETS MAA",plotlyOutput('petsMAA'))
                                       
                                       ),
                              tabPanel("MAM",
                                       mainPanel("ETS MAM",plotlyOutput('petsMAM'))
                                       
                                       ),
                              tabPanel("MMN",
                                       mainPanel("ETS MMN",plotlyOutput('petsMMN'))
                                       
                                       
                                       ),
                              tabPanel("MMM",
                                       mainPanel("ETS MMM",plotlyOutput('petsMMM'))
                                       
                                       )
                                ),
                   tabPanel("Long ARIMA",
                            sidebarLayout(position = "right",
                                          sidebarPanel("Please Wait for calculations to complete and graph to load."),
                                          
                                          mainPanel("ARIMA Model",plotlyOutput('pA'))
                                          
                            )
                            
                            ),
                   navbarMenu("More",
                              tabPanel("Read Me",includeMarkdown("User Guide.md"))
                            
                              )
                   
))