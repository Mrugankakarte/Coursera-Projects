Forecasting Application
========================================================
author:Mrugank Akarte 
date:August 9,2016 
autosize: true
transition: fade

Introduction
=======================================================
The basic idea behind this applicaton is to allow a user to compare the forecasts of data using different methods within few clicks of a button.

Link for source code of [ui.R](https://github.com/Mrugankakarte/Coursera-Data-Product/tree/master/project) and [server.R](https://github.com/Mrugankakarte/Coursera-Data-Product/tree/master/project).  
The link for application can be found [here](https://mrugankakarte.shinyapps.io/Project/)

Working
========================================================
- Sample data file for demo is available [here](https://github.com/Mrugankakarte/Coursera-Data-Product/tree/master/project/demo-data-file).  
- Once the data is loaded, user can see the preview of the data.  
- Further the interactive time series plot is displayed in the _Plot_ section.  
- The _Forecast_ section forecasts the data using available different methods. Brief description of each is available in their respective tabs.  
- The _Error Table_ section shows different types of errors like mean error, root mean square error, mean percentage error, mean absolute percentage error, etc. The _AICc_ values are also provided for comparing different ETS Models. 


Working (Continued...)
========================================================
- ETS forecast shown in _Forecast_ section automaticallys selects the appropriate model which at times may be incorrect. Hence a seperate _ETS_ tab is provided where all the ETS Models with their forecasts can be seen.
- The _Long ARIMA_ tab calculates the forecasts withot any approximations and searches over all methods.

__Limitations__
- Some knowledge of forecasting is required to understand the graphs and error table completely.
- Data file of specific format and extension is required.

Sample data with plot
========================================================
left: 40%
![plot of chunk unnamed-chunk-1](ForecastingApp-figure/unnamed-chunk-1-1.png)
***

```
       Month Year Amount
1    January 2000  45353
2   February 2000  76363
3      March 2000  74549
4      April 2000  59487
5        May 2000  90125
6       June 2000  84612
7       July 2000  80123
8     August 2000  72465
9  September 2000  86412
10   October 2000  91045
11  November 2000  83216
12  December 2000  74162
13   January 2001  70549
14  February 2001  66813
15     March 2001  60894
16     April 2001  64879
```

