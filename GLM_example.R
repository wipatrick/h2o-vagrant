# Load h2o packages
install.packages("h2o")

# Connect to h2o cluster
library(h2o)
localH2O = h2o.init(ip = "192.168.33.10", port = 54321, startH2O = TRUE)

# Successfully connected to http://192.168.33.10:54321/ 
#  
# R is connected to the H2O cluster: 
#   H2O cluster uptime:         3 minutes 58 seconds 
#   H2O cluster version:        3.6.0.8 
#   H2O cluster name:           myh2ocluster 
#   H2O cluster total nodes:    3 
#   H2O cluster total memory:   11.60 GB 
#   H2O cluster total cores:    3 
#   H2O cluster allowed cores:  3 
#   H2O cluster healthy:        TRUE

# Info Generalized Linear Models
?h2o.glm

# Demo with H2O Generalized Linear Models

# Small airline dataset ~4.5 MB: https://s3.amazonaws.com/h2o-airlines-unpacked/allyears2k.csv
airlinesURL = "https://s3.amazonaws.com/h2o-airlines-unpacked/allyears2k.csv"
airlines_new.hex = h2o.importFile(path = airlinesURL, destination_frame = "airlines_new.hex")
summary(airlines.hex)

# View quantiles and histograms
quantile(x = airlines.hex$ArrDelay, na.rm = TRUE)
h2o.hist(airlines.hex$ArrDelay)

# Find number of flights by airport
originFlights = h2o.group_by(data = airlines.hex, by = "Origin", nrow("Origin"),gb.control=list(na.methods="rm"))
originFlights.R = as.data.frame(originFlights)

# Find number of flights per month
flightsByMonth = h2o.group_by(data = airlines.hex, by = "Month", nrow("Month"), gb.control=list(na.methods="rm"))
flightsByMonth.R = as.data.frame(flightsByMonth)

# Find months with the highest cancellation ratio
which(colnames(airlines.hex)=="Cancelled")
cancellationsByMonth = h2o.group_by(data = airlines.hex, by = "Month", sum("Cancelled"), gb.control=list(na.methods="rm"))
cancellation_rate = cancellationsByMonth$sum_Cancelled/flightsByMonth$nrow_Month
rates_table = h2o.cbind(flightsByMonth$Month, cancellation_rate)
rates_table.R = as.data.frame(rates_table)

# Construct test and train sets using sampling
airlines.split = h2o.splitFrame(data = airlines.hex, ratios = 0.85)
airlines.train = airlines.split[[1]]
airlines.test = airlines.split[[2]]

# Display a summary using table-like functions
h2o.table(airlines.train$Cancelled)
h2o.table(airlines.test$Cancelled)

# Set predictor and response variables
Y = "IsDepDelayed"
X = c("Origin", "Dest", "DayofMonth", "Year", "UniqueCarrier", "DayOfWeek", "Month", "DepTime", "ArrTime", "Distance")

# Define the data for the model and display the results
airlines.glm <- h2o.glm(training_frame=airlines.train, x=X, y=Y, family = "binomial", alpha = 0.5)

# View model information: training statistics, performance, important variables
summary(airlines.glm)

# Predict using GLM model
pred = h2o.predict(object = airlines.glm, newdata = airlines.test)

# Look at summary of predictions
summary(pred)
