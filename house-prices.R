# get.years <- function(y) {
#   dt <- read.csv(paste0("http://www.landregistry.gov.uk/market-trend-data/public-data/price-paid-data/price-paid-data-", y), header = FALSE)
#   assign(paste(y), dt, envir = .GlobalEnv)
# }
# years are in separate links
#-----------------------------------------


mon.url  <- c(
"http://www.landregistry.gov.uk/__data/assets/file/0003/34806/PPMS_Jan_2013_ew_with-columns.csv",
"http://www.landregistry.gov.uk/__data/assets/file/0003/37551/PPMS_Feb_2013_ew_with-columns.csv",
"http://www.landregistry.gov.uk/__data/assets/file/0016/40354/PPMS_Mar_2013_ew_with-columns.csv",
"http://www.landregistry.gov.uk/__data/assets/file/0007/42739/PPMS_Apr_2013_ew_with-columns.csv",
"http://www.landregistry.gov.uk/__data/assets/file/0019/46090/PPMS_May_2013_ew_with-columns.csv",
"http://www.landregistry.gov.uk/__data/assets/file/0005/49505/PPMS_Jun_2013_ew_with-columns.csv")

var.names <- c("id", "price", "date", "postcode", "type", "new", "hold", "no", "no2", "street", "locality", "town", "authority", "county", "status")

get.prices <- function(m, u) {
   dt <- read.csv(u, header = FALSE, stringsAsFactors = FALSE)
   assign(paste0(m), dt, envir = .GlobalEnv)
 }
#Fetch the data, available months
mapply(get.prices, month.abb[1:6], mon.url)


for (mo in grep('^[A-Z].', ls(), value = TRUE)) {
  colnames(mo) <- var.names
}


mon.df <- mget(month.abb[1:6])
sapply(mon.df, function(x) colnames(x) <- var.names)

colnames(Jan) <- var.names
colnames(Feb) <- var.names
colnames(Mar) <- var.names
colnames(Apr) <- var.names
colnames(May) <- var.names
colnames(Jun) <- var.names

library(plyr)
prices <-  rbind.fill(month.abb[1:6])
prices <-  rbind.fill(Jan, Feb, Mar, Apr, May, Jun)

#prices$date  <- strptime(prices$date, "%d/%m/%Y %H:%M")
library(lubridate)
prices$date  <- dmy_hm(prices$date)


#------------------------------
prices[grep("E2 0RF", prices$postcode), ]
prices[grep("OLD FORD ROAD", prices$street), ]
prices[grep("MACE STREET", prices$street), ]

summary(prices$date)
