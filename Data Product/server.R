library(ggplot2)
library(plotly)
library(ggfortify)
library(fpp)


shinyServer(function(input, output, session) {
  
  output$contents <- renderTable({
    timeseries()
    
  })
  
  demo <- reactive({
    t<-matrix(c("January",2010,45353,"February",2010,76363,"March",2010,74564,"April",2010,23425,"May",2010,90787,"June",2010,89679,"July",2010,89465,"August",2010,13513,"September",2010,86464,"October",2010,46518,"November",2010,47852,"December",2010,36541,"January",2011,14526,"February",2011,65475,"March",2011,78951), byrow = T, ncol = 3)
    colnames(t)<-c("Month", "Year", "Amount")
    t<-as.table(t)
    row.names(t)<-NULL
    t
  })
  
  output$demo <- renderTable({
    demo()
    
  },include.rownames = F)
  
  
  timeseries<- reactive({
          #inFile$datapath <- reactiveFileReader(intervalMillis = 1000,readFunc = read.csv,filePath =url("https://raw.githubusercontent.com/Mrugankakarte/Coursera-Projects/master/Data%20Product/Demo%20data%20file/demo.csv"))
    
     if(input$choice1 == "x1")
           {
           
           inFile <- input$file1 
           if (is.null(inFile))
                 return(NULL)
           
           x<-read.csv(inFile$datapath)
        
     }
        
        
    if(input$choice1 == "x2")
    {
          inFile <-read.csv(url("https://raw.githubusercontent.com/Mrugankakarte/Coursera-Projects/master/Data%20Product/Demo%20data%20file/demo.csv"))
          
          x<- inFile

    }

     x.ts<-ts(x$Amount, frequency = 12, start = c(x$Year[1],1))
    x.ts
  })
 
   output$plot <- renderPlotly({
    g<-autoplot(timeseries())+xlab("Time")+ylab("Amount")
    gg<-ggplotly(g)
    gg
  })


#TIME SERIES DECOMPOSITION    
  TSD1 <-reactive({
    fit<-stl(timeseries(),na.action = na.omit,s.window = "periodic", robust = T)
    fit
  })
  TSD1F <-reactive({
    fit<-TSD1()
    fcastTSD <- forecast(fit, method="naive")
    fcastTSD
   
  })
  
  output$TSD <- renderDataTable({
      x<-TSD1()
      x1<-forecast(x)
      x1
    
  })
  
  output$pTSD <- renderPlotly({
    
    g<-autoplot(TSD1F())+xlab("Time")+ylab("Amount")
    gg<-ggplotly(g)
    gg
 })

#SIMPLE EXPONENTIAL SMOOTHING    
 SE1 <- reactive({
   fitSE<-ses(timeseries(),h = 5)
   fitSE
 })
 
 SE1F <- reactive({
   fit<-SE1()
   fcastSE <- forecast(fit)
   fcastSE
   
 })
 
  output$pSE <- renderPlotly({
    
    g<-autoplot(SE1F())+xlab("Time")+ylab("Amount")
    gg<-ggplotly(g)
    gg
  })
  
#HOLT'S LINEAR TREND
  
  HL1 <- reactive({
    fitHL<-holt(timeseries(),h = 5,level = c(95))
    fitHL
  })
  
  HL1F <- reactive({
    fit<-HL1()
    fcastHL <- forecast(fit)
    fcastHL
    
  })
  
  output$pHL <- renderPlotly({
    
    g<-autoplot(HL1F())+xlab("Time")+ylab("Amount")
    gg<-ggplotly(g)
    gg
  })
  
#HOLT WINTERS SEASONAL
  
  HW1 <- reactive({
    fitHW<-hw(timeseries(),level = c(95))
    fcastHW <- forecast(fitHW)
    fcastHW
  })
  
  HW1M <- reactive({
    fit<-hw(timeseries(), level = c(95), seasonal = "multiplicative")
    fcastHWM<-forecast(fit)
    fcastHWM
  })
  
  output$pHW <- renderPlotly({
    
    g<-autoplot(HW1())+xlab("Time")+ylab("Amount")
    gg<-ggplotly(g)
    gg
  }) 
  
  output$pHWM <- renderPlotly({
    
    g<-autoplot(HW1M())+xlab("Time")+ylab("Amount")
    gg<-ggplotly(g)
    gg
  })
#ETS MODEL
  
  ets1 <- reactive({
    fitets<-ets(timeseries())
    fitets
  })
  
  ets1F <- reactive({
    fit<-ets1()
    fcastets <- forecast(fit)
    fcastets
    
  })
  
  output$pets <- renderPlotly({
    
    g<-autoplot(ets1F())+xlab("Time")+ylab("Amount")
    gg<-ggplotly(g)
    gg
  }) 

#ARIMA
  a1 <- reactive({
    fita<-auto.arima(x = timeseries())
    fita
  })
  
  aA1 <- reactive({
    fitA<-auto.arima(x = timeseries(), stepwise = F, approximation = F)
    fitA
  })
  
  a1F <- reactive({
    fit<-a1()
    fcasta <- forecast(fit)
    fcasta
    
  })
 
  aA1F <- reactive({
    fit<-aA1()
    fcastA <- forecast(fit)
    fcastA
    
  })
  
  
  output$a1 <- renderText({
    nsdiffs(timeseries())
  })
  
  output$a2 <- renderText({
    ndiffs(timeseries())
  })
  
   
  output$pa <- renderPlotly({
    
    g<-autoplot(a1F())+xlab("Time")+ylab("Amount")
    gg<-ggplotly(g)
    gg
  })
  
  output$pA <- renderPlotly({
    
    g<-autoplot(aA1F())+xlab("Time")+ylab("Amount")
    gg<-ggplotly(g)
    gg
  })
  
  output$errtableTSD <- renderTable({
    aTSD<-accuracy(TSD1F())[,drop = F]
  })
  
  output$errtableSE <- renderTable({
    aSE<-accuracy(SE1())[,drop = F]
  })
  
  output$errtableHL <- renderTable({
    aHL<-accuracy(HL1())[,drop = F]
    
  })
  
  eHW <- reactive({
    x<- matrix(c(accuracy(HW1()),accuracy(HW1M())),byrow = T, nrow = 2)
    colnames(x)<-c("ME","RMSE","MAE","MPE","MAPE","MASE","ACF1")
    rownames(x)<-c("Additive","Multiplicative")
    x<-as.table(x)
    x
  })
  
  output$errtableHW <- renderTable({
    eHW()
  })
  
  output$errtableETS <- renderTable({
    aETS<-accuracy(ets1())[,drop = F]
  })
  
  output$errtableA <- renderTable({
    aA<-accuracy(a1())[,drop = F]
  })
  
  etsANN <- reactive({
      ANN<-ets(timeseries(), model = "ANN")  
      ANN})
  
  etsANN1 <- reactive({
      ANN <- etsANN()
      fcastANN<-forecast(ANN)
      fcastANN
  }) 

  output$petsANN <- renderPlotly({
    
    g<-autoplot(etsANN1())+xlab("Time")+ylab("Amount")
    gg<-ggplotly(g)
    gg
  })
  
  etsAAN <- reactive({
    AAN<-ets(timeseries(), model = "AAN")  
    AAN})
  
  etsAAN1 <- reactive({
    AAN <- etsAAN()
    fcastAAN<-forecast(AAN)
    fcastAAN
  }) 
  
  output$petsAAN <- renderPlotly({
    
    g<-autoplot(etsAAN1())+xlab("Time")+ylab("Amount")
    gg<-ggplotly(g)
    gg
  })
  
  etsAAA <- reactive({
    AAA<-ets(timeseries(), model = "AAA")  
    AAA})
  
  etsAAA1 <- reactive({
    AAA <- etsAAA()
    fcastAAA<-forecast(AAA)
    fcastAAA
  }) 
  
  output$petsAAA <- renderPlotly({
    
    g<-autoplot(etsAAA1())+xlab("Time")+ylab("Amount")
    gg<-ggplotly(g)
    gg
  })
  
  etsANA <- reactive({
    ANA<-ets(timeseries(), model = "ANA")  
    ANA})
  
  etsANA1 <- reactive({
    ANA <- etsANA()
    fcastANA<-forecast(ANA)
    fcastANA
  }) 
  
  output$petsANA <- renderPlotly({
    
    g<-autoplot(etsANA1())+xlab("Time")+ylab("Amount")
    gg<-ggplotly(g)
    gg
  })
  
  etsMNN <- reactive({
    MNN<-ets(timeseries(), model = "MNN")  
    MNN})
  
  etsMNN1 <- reactive({
    MNN <- etsMNN()
    fcastMNN<-forecast(MNN)
    fcastMNN
  }) 
  
  output$petsMNN <- renderPlotly({
    
    g<-autoplot(etsMNN1())+xlab("Time")+ylab("Amount")
    gg<-ggplotly(g)
    gg
  })
  
  etsMNA <- reactive({
    MNA<-ets(timeseries(), model = "MNA")  
    MNA})
  
  etsMNA1<- reactive({
    MNA<-etsMNA()
    fcastMNA<-forecast(MNA)
    fcastMNA
  }) 
  
  output$petsMNA <- renderPlotly({
    
    g<-autoplot(etsMNA1())+xlab("Time")+ylab("Amount")
    gg<-ggplotly(g)
    gg
  })
  
  etsMNM <- reactive({
    MNM<-ets(timeseries(), model = "MNM")  
    MNM})
  
  etsMNM1<-reactive({
    MNM<-etsMNM()
    fcastMNM<-forecast(MNM)
    fcastMNM
  }) 
  
  output$petsMNM <- renderPlotly({
    
    g<-autoplot(etsMNM1())+xlab("Time")+ylab("Amount")
    gg<-ggplotly(g)
    gg
  })
  
  etsMAN <- reactive({
    MAN<-ets(timeseries(), model = "MAN")  
    MAN})
  
  etsMAN1<-reactive({
    MAN<-etsMAN()
    fcastMAN<-forecast(MAN)
    fcastMAN
  }) 
  
  output$petsMAN <- renderPlotly({
    
    g<-autoplot(etsMAN1())+xlab("Time")+ylab("Amount")
    gg<-ggplotly(g)
    gg
  })
  
  etsMAA <- reactive({
    MAA<-ets(timeseries(), model = "MAA")  
    MAA})
  
  etsMAA1<-reactive({
    MAA<-etsMAA()
    fcastMAA<-forecast(MAA)
    fcastMAA
  }) 
  
  output$petsMAA <- renderPlotly({
    
    g<-autoplot(etsMAA1())+xlab("Time")+ylab("Amount")
    gg<-ggplotly(g)
    gg
  })
  
  etsMAM <- reactive({
    MAM<-ets(timeseries(), model = "MAM")  
    MAM})
  
  etsMAM1<-reactive({
    MAM<-etsMAM()
    fcastMAM<-forecast(MAM)
    fcastMAM
  }) 
  
  output$petsMAM <- renderPlotly({
    
    g<-autoplot(etsMAM1())+xlab("Time")+ylab("Amount")
    gg<-ggplotly(g)
    gg
  })
  
  etsMMN <- reactive({
    MMN<-ets(timeseries(), model = "MMN")  
    MMN})
  
  etsMMN1<-reactive({
    MMN<-etsMMN()
    fcastMMN<-forecast(MMN)
    fcastMMN
  }) 
  
  output$petsMMN <- renderPlotly({
    
    g<-autoplot(etsMMN1())+xlab("Time")+ylab("Amount")
    gg<-ggplotly(g)
    gg
  })
  
  etsMMM <- reactive({
    MMM<-ets(timeseries(), model = "MMM")  
    MMM})
  
  etsMMM1<-reactive({
    MMM<-etsMMM()
    fcastMMM<-forecast(MMM)
    fcastMMM
  }) 
  
  output$petsMMM <- renderPlotly({
    
    g<-autoplot(etsMMM1())+xlab("Time")+ylab("Amount")
    gg<-ggplotly(g)
    gg
  })
  
  Etstable <- reactive({
    etable<-matrix(c(etsANN()$aicc,accuracy(etsANN())[c(2,3,5)],
                     etsAAN()$aicc,accuracy(etsAAN())[c(2,3,5)],
                     etsAAA()$aicc,accuracy(etsAAA())[c(2,3,5)],
                     etsANA()$aicc,accuracy(etsANA())[c(2,3,5)],
                     etsMNN()$aicc,accuracy(etsMNN())[c(2,3,5)],
                     etsMNA()$aicc,accuracy(etsMNA())[c(2,3,5)],
                     etsMNM()$aicc,accuracy(etsMNM())[c(2,3,5)],
                     etsMAN()$aicc,accuracy(etsMAN())[c(2,3,5)],
                     etsMAA()$aicc,accuracy(etsMAA())[c(2,3,5)],
                     etsMAM()$aicc,accuracy(etsMAM())[c(2,3,5)],
                     etsMMN()$aicc,accuracy(etsMMN())[c(2,3,5)],
                     etsMMM()$aicc,accuracy(etsMMM())[c(2,3,5)]) , ncol = 4, byrow = T)
    colnames(etable)<-c("AICc","RMSE","MAE","MAPE")
    row.names(etable)<-c("ANN","AAN","AAA","ANA","MNN","MNA","MNM","MAN","MAA","MAM","MMN","MMM")
    etable<-as.table(etable)
    etable
  })
  
  output$Etstable <- renderTable({
    Etstable()
  })
})