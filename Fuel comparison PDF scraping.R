#####################################################
#
# Scraping tables from PDFs 
# 
# Scraping a table with comparison between
# hydrogen and other fuels
#
#####################################################

# Calling on libraries
library(pdftools)
library(stringr)
library(dplyr)


# Read PDF to R.
fuel <- pdf_text("https://www.mdpi.com/1996-1073/12/23/4593/pdf")


# Extract the page that contains the table with comparison of different fuels, 
# which is on page 5.
fuel <- fuel[5]


# Split filecontent by newline character
fuel <- str_split(fuel, pattern = "\n")


# str_split() converts the data to a list. Keep first element of this list.
fuel <- fuel[[1]]


## Remove whitespace from start and end of string
fuel <- str_trim(fuel)


# Based on the PDF, we want every row in Table 2.
# To keep only the rows that we want, we can combine str_which() and 
# subsetting to find the rows from Table 2.
#    Note that we leave the column names out. It is easier to add them back after 
#    we have created the data frame, and then make appropriate names.
str_which(fuel, pattern = "Liquid hydrogen")      # Row 40
str_which(fuel, pattern = "Coal")                 # Row 51


# Keep all rows between those two values
fuel <- fuel[str_which(fuel, pattern = "Liquid hydrogen"):
               str_which(fuel, pattern = "Coal")]


# Now we can look at the first six rows of this data.
head(fuel)



# Create a data.frame from the character vector. 

## First, we will put the data into columns. We want 5 columns.
## Our split will be "\\s{2,}“. That is, a space that occurs two or more times
fuel_split <- str_split_fixed(fuel, "\\s{2,}", 5)


## Look at the data
head(fuel_split)


## Putting the data in a tibble()
fuel_split <- as_tibble(fuel_split)


## Provide names to the columns
names(fuel_split) <- c("Fuel",
                       "Mass",
                       "Volume",
                       "Reserve",
                       "Emission")


# Checking the data type of the columns
sapply(fuel_split, class)   # All columns are of type character


# Replace the missing values noted as "-" with NAs
fuel_split <- replace(fuel_split, fuel_split == "-", NA)


# Convert the data type to numeric for the numbers
fuel_split[, 2:5] <- sapply(fuel_split[, 2:5], as.numeric)


# Controll the data type of the columns
sapply(fuel_split, class)


# Now we can save the file as a csv. You can specify the path to select where
# you would like to download the csv.
write.csv(fuel_split, "~/Documents/Data analytics/Fuel_comparison.csv", 
          row.names = FALSE)

