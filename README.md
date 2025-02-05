# get_USGSFlow
Queries the USGS's National Water Dashboard to download daily average discharge data.

# Background Information 
The USGS houses a wealth of current and historical discharge data that is often useful for IDEQ purposes. To access flow data, you can go to their website (https://dashboard.waterdata.usgs.gov/app/nwd/en/) or you can use this R script. Please note that the USGS is currently in the process of updating their data infrastructure. Please let me know if you run into issues that may be related to broken functions as a result (I'm not sure if or when these functions might be impacted). This script was developed to download daily average discharge data from user provided information and provide basic trend analysis graphs for all sites. For additional information on trend analysis interpretations, please visit the EGRET User Guide (https://pubs.usgs.gov/publication/tm4A10).

# Getting Started 
To get started, specify the user inputs listed at the beginning of the file: station ID #, start date, end date, and your computer username. Be sure to follow the formatting guidelines provided within the script. Once the user-specified inputs are provided, click on "Source" and watch the console to see if you run into any errors and additional prompts. When the console asks you if you want to make a new directory, say yes. There will also be additional, optional prompts related to the USGS station name and units. 

If the script ran successfully, a new folder will appear in your Downloads folder including: an Excel file with daily average discharge data, timeseries graphs for all sites, trend analysis graphs for all sites using all data, trend analysis graphs for all sites using only spring high-flow data, trend analysis graphs for all sites using only summer low-flow data. 
