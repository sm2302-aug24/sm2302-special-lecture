library(tidyverse)
library(quanteda)
library(quanteda.textplots)
library(quanteda.textstats)
library(quanteda.textmodels)
library(readtext)

# For modelling
library(seededlda)
library(LSX)
library(lubridate)  # for handling dates
library(ggdendro)

## ---- Quantitative data ------------------------------------------------------
path_data <- system.file("extdata/", package = "readtext")
dat_inaug <- read_csv(paste0(path_data, "/csv/inaugCorpus.csv"))

dat_inaug$texts[1]

tsv_file <- paste0(path_data, "/tsv/dailsample.tsv")
cat(readLines(tsv_file, n = 4), sep = "\n")  # first 3 lines

path_udhr <- paste0(path_data, "/txt/UDHR")
list.files(path_udhr)  # list the files in this folder

#



















## ---- Workflow ---------------------------------------------------------------






## ---- Statistical analysis ---------------------------------------------------


## ---- Modelling --------------------------------------------------------------
