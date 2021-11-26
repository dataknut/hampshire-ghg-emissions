# data: https://www.carbon.place/data/
# Morgan, Malcolm, Anable, Jillian, & Lucas, Karen. (2021). A place-based carbon calculator for England. Presented at the 29th Annual GIS Research UK Conference (GISRUK), Cardiff, Wales, UK (Online): Zenodo. http://doi.org/10.5281/zenodo.4665852

# Parameters ----
# CREDS make available:
# LSOA level (per capita)
lsoaF <- "PBCC_LSOA_data.csv"
# LA level (mean per capita averaged over LSOAs) ?
laF <- "la_averages.csv"

dataPath <- "~/Dropbox/data/CREDS/carbon.place/PBCC_LSOA_data/"

# Libraries ----
library(data.table)
library(here)
library(skimr)

# Functions ----
source(here::here("R", "functions.R"))

# Load data ----
creds_laDT <- data.table::fread(paste0(dataPath, laF))

creds_lsoaDT <- data.table::fread(paste0(dataPath, lsoaF))

# identical variables?
length(names(creds_laDT))
la_names <- as.data.table(names(creds_laDT))
la_names[, source := "LA"]
length(names(creds_lsoaDT))
lsoa_names <- as.data.table(names(creds_lsoaDT))
lsoa_names[, source := "LSOA"]

names <- merge(lsoa_names, la_names, by = "V1", all = TRUE)
# what's missing?
names[is.na(source.y)]
# nothing unexpected

# check what is in there
creds_laDT_reduced <- creds_laDT[, .(LAD17NM, pop_2018, # add vars as needed
                                     total_kgco2e_percap)]
summary(creds_laDT_reduced)
creds_laDT_reduced[pop_2018 > 100000]
# so we need to remove 'LAD17NM' if it is not actually an LA
# use the LSOA data to give us a spine

districts <- creds_lsoaDT[, .(nObs = .N), keyby = .(LAD17CD,LAD17NM)]

nrow(districts)
nrow(creds_laDT)

# so it's only 1 that's different - 'England'
# in that case we won;t worry, just select the Solent LAs as usual
creds_laDT_reduced[, la_name := LAD17NM]
creds_solent_laDT <- getSolent(creds_laDT_reduced)

# should be 14
nrow(creds_solent_laDT)
creds_solent_laDT

# total kT CO2e
creds_solent_laDT[, kT_co2e_creds := (pop_2018 * total_kgco2e_percap)/1000000]
creds_solent_laDT

sum(creds_solent_laDT$kT_co2e_creds)

# load in the estimates from the other sources
compareDT <- data.table::fread(here::here("data", 
                                          "all_hampshire_districts_sum_ktCO2(e)_v1_methods.csv"))

setkey(creds_solent_laDT, la_name)
setkey(compareDT, District)

dt <- compareDT[creds_solent_laDT[, .(la_name, kT_co2e_creds)]]

plotDT <- melt(dt[, .(District, `BEIS territorial emissions (kt CO2, 2019)`,
                       `CSE territorial emissions (kt CO2e)`,
                       `CSE consumption emissions (kt CO2e)`,
                       `CREDS consumption emissions (kt CO2e)` = kT_co2e_creds)])

p <- ggplot2::ggplot(plotDT, aes(x = reorder(District, -value), y = value, fill = variable)) +
  geom_col(position = "dodge") +
  scale_fill_discrete(name = "Method") +
  coord_flip() +
  guides(fill=guide_legend(ncol=2)) +
  theme(legend.position="bottom") +
  labs(x = "District",
       y = "kT CO2(e)",
       cap = "Ordered")
 
p
 
ggplot2::ggsave(here::here("plots", "comparisonAllMethodsByDistrict.png"), p)

# how much higher are the CREDS consumption estimates?
dt[, pc_diff_cons := (100*kT_co2e_creds/`CSE consumption emissions (kt CO2e)`)-100]

dt

skimr::skim(dt)
