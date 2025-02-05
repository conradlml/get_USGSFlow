
################################################################################
# Direct flow data download from the USGS. 
# 
# Lily Conrad, IDEQ State Office
# last update: 2/5/2025
#
# Data citation: 
# U.S. Geological Survey, 2016, National Water Information System data available 
# on the World Wide Web (USGS Water Data for the Nation), accessed MMMM DD, YYYY, 
# at URL http://waterdata.usgs.gov/nwis/.
################################################################################


# To get started, provide the user inputs below following the outlined format.


### User inputs ----------------------------------------------------------------

# Enter the USGS station ID you are interested in. If you don't know the station
# ID, check the website provided above. If you want to look at multiple stations,
# separate them by a comma inside the parentheses with each in its own set of 
# quotation marks.
siteNumber <- c(13338500, 13341050)


# Enter the start date (yyyy-mm-dd) and start year (YYYY) for your period of interest.
start <- "2000-01-01"
start.year <- 2000

# Enter the end date (yyyy-mm-dd) and end year (YYYY) for your period of interest.
end <- "2020-12-31"
end.year <- 2020

# Enter your username (the name at the beginning of your computer's file explorer
# path) in quotations.
my_name <- "jdoe"


# Now that you've entered the values above, click on "Source" and watch
# your console for errors. If the script ran successfully, there will be a new
# folder with several items in your Downloads folder. 



################################################################################
#                                 START
################################################################################

### Load packages and data -----------------------------------------------------

my_packages <- c("dplyr", "openxlsx", "EGRET", "ggplot2", "lubridate", "dataRetrieval")
install.packages(my_packages, repos = "http://cran.rstudio.com")

library(dplyr)
library(openxlsx)
library(EGRET)
library(ggplot2)
library(lubridate)
library(dataRetrieval)


### Retrieve discharge data ----------------------------------------------------

# Data query.  
parameterCd <- "00060" # daily average discharge code 
rawDailyDataUSGS <- readNWISdv(siteNumber, parameterCd, start, end)

# Site query.
Info <- readNWISsite(siteNumber)
site_names <- Info %>%  
  select(site_no, station_nm)

# Add in site names.
q.dat <- merge(x = rawDailyDataUSGS, y = site_names, by = "site_no")

# Formatting.
q.dat <- q.dat %>% 
  rename(daily_avg_discharge_cfs = X_00060_00003,
         data_value_qual_code = X_00060_00003_cd)



### Making plots ---------------------------------------------------------------

# ggplot timeseries, separate plot for each site  
site_list <- siteNumber
for (i in site_list) {
  temp_plot <- q.dat %>%
    filter(site_no == i) %>%
    ggplot(aes(x = Date, y = daily_avg_discharge_cfs)) +
    geom_line(alpha = 0.6) + 
    labs(y = "Daily Mean Discharge (cfs)",
         x = "Calendar Year",
         title = paste0("USGS Station ",i),
         subtitle = subset(q.dat$station_nm, q.dat$site_no == i)) +
    scale_x_date(date_labels = "%Y") +
    theme_bw() 
  print(temp_plot)
  ggsave(paste0("C:/Users/",my_name,"/Downloads/",Sys.Date(),"_","USGS_download/plot_ts_",i,".png"), 
         plot = temp_plot,
         width = 6,
         height = 6, 
         units = "in") 
}


# Egret trend analysis, separate plot for each site
siteID <- siteNumber
for(i in siteID){
  daily <- readNWISDaily(i, parameterCd, start, end)
  INFO <- readNWISInfo(i, parameterCd)
  
  # Egret functions & plots using all data
  eList <- as.egret(INFO, daily, NA, NA)
  jpeg(paste0("C:/Users/", my_name,"/Downloads/",Sys.Date(),"_","USGS_download/plot_alltrends_",i,".jpg"))
  plotFour(eList, qUnit = 3) # plot trends for min daily, mean daily, 7 day min, stdev of log(Q)
  dev.off()
  
  # Egret functions & plots using spring high flow period only (Apr-Jun)
  elist_spring <-as.egret(INFO, daily, NA, NA)
  elist_spring <-setPA(elist_spring, paStart = 4, paLong = 3)
  jpeg(paste0("C:/Users/", my_name,"/Downloads/",Sys.Date(),"_","USGS_download/plot_springtrends_",i,".jpg"))
  plotFour(elist_spring, qUnit = 3) # plot trends for min daily, mean daily, 7 day min, stdev of log(Q)
  dev.off()
  
  # Egret functions & plots using summer low flow period only
  elist_summer <-as.egret(INFO, daily, NA, NA)
  elist_summer <-setPA(elist_summer, paStart = 7, paLong = 3)
  jpeg(paste0("C:/Users/", my_name,"/Downloads/",Sys.Date(),"_","USGS_download/plot_summertrends_",i,".jpg"))
  plotFour(elist_summer, qUnit = 3) # plot trends for min daily, mean daily, 7 day min, stdev of log(Q)
  dev.off()
}


### Save discharge data --------------------------------------------------------

# Save the data to excel. This will save the file in your downloads folder
# Adjust the file path if you'd like it to save somewhere else.
write.xlsx(q.dat, paste0("C:/Users/",my_name,"/Downloads/",Sys.Date(),"_","USGS_download/data_daily-mean-Q.xlsx"))



################################################################################
#                                 END
################################################################################
