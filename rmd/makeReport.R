# render the reports and save to /docs for github pages

# Packages ----
library(here)
library(rmarkdown)
library(bookdown)

# Functions ----
makeReport <- function(f){
  # default = whatever is set in yaml
  rmarkdown::render(input = here::here("rmd", paste0(f, ".Rmd")),
                    #output_format ="all", # output all formats specified in the rmd
                    output_file = paste0(here::here("docs/"), f, ".html")
  )
}

# versions
# 1.0 = original
# 1.1 = CSE data update

versions <- c("2.0")

for(v in versions){
  f <- paste0("widerHampshire_GHG_Emissions_v", v)
  makeReport(f)
}
