
# _Forecasting Application_  
This application is used to check forecast for given data. The value of forecast can be seen on interactive graph produced by each forecasting method.  

### IMPORTANT:  

1. It is not necessary that all forecasting methods will be applicable for given data. 

2. This application shows forecast using each method **regardless of whether the forecasting method is applicable or not.**

3. User is requested to select appropriate forecast model with the help of error table provided in the _Error Table_ section. For selecting the apprpriate model some knowledge of forecasting is essential.

4. In case of _ARIMA Model_, forecast is calculated using the default R method i.e by using the following command   
`auto.arima(x = , stepwise = T, approximation = T)`  

5. Please wait while using _long ARIMA_ option. Loading of graph might take a while. Computation of forecasting using this method takes more time.

## Using Forecasting Application

1.While uploading data file please ensure that a file of correct format and extension(.csv) is being uploaded.

2.Data file for demo purpose is available [here](https://github.com/Mrugankakarte/Coursera-Projects/tree/master/Data%20Product/Demo%20data%20file).

3.Once correct data is uploaded you should be able to see a preview of your data.

4.Please wait for graphs and data to load completely.

5.Each graph can be zoomed in/out using the buttons situated above the graph or by dragging with mouse on desired location.

6.Brief description of each forecasting method is avialable in thier respective tabs.
