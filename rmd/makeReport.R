# render the reports and save to /docs for github pages

# Packages ----
library(here)
library(bookdown)

# Functions ----
makeReport <- function(f){
  # default = whatever is set in yaml
  rmarkdown::render(input = here::here("rmd", paste0(f, ".Rmd")),
                    params = list(title = title,
                                  subtitle = subtitle,
                                  parish = parish),
                    output_format = "html_document2",
                    output_file = paste0(here::here("docs/"), f, ".html")
  )
  # there must be some way of preserving the .md and just running pandoc?
  rmarkdown::render(input = here::here("rmd", paste0(f, ".Rmd")),
                    params = list(title = title,
                                  subtitle = subtitle,
                                  parish = parish),
                    output_format = "word_document2",
                    output_file = paste0(here::here("docs/"), f, ".docx")
  )
}

# versions
# 1.0 = original
# 1.1 = CSE data update

versions <- c("1.0", "1.1")

for(v in versions){
  f <- paste0("Hampshire_County_GHG_Emissions_v", v)
  makeReport(f)
}
