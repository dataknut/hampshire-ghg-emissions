# useful functions
# to use these in a .Rmd file put this in the setup chunk:
# source(here::here("R", "functions.R"))
# you may need to install the here package first

getSolent <- function(df){
  # function to return the rows that match on Local Authority name
  # assumes we're matching on la_name
  # this aligns with the .shp boundary file we pre-created
  solent <- dplyr::filter(df, la_name == "Basingstoke and Deane"|
                            la_name == "East Hampshire"|
                            la_name == "Eastleigh"|
                            la_name == "Fareham"|
                            la_name == "Gosport"|
                            la_name == "Hart"|
                            la_name == "Havant"|
                            la_name == "New Forest"|
                            la_name == "Portsmouth"|
                            la_name == "Rushmoor"| # northern Hampshire - not always considered part of Solent
                            la_name == "Southampton"|
                            la_name == "Test Valley"|
                            la_name == "Winchester"|
                            la_name == "Isle of Wight"
  )
  return(solent)
}

flagSolent <- function(df){
  # function to return the rows that match on Local Authority name
  # assumes we're matching on la_name
  # this aligns with the .shp boundary file we pre-created
  solent <- dplyr::mutate(df, solentFlag = ifelse(la_name == "Basingstoke and Deane"|
                            la_name == "East Hampshire"|
                            la_name == "Eastleigh"|
                            la_name == "Fareham"|
                            la_name == "Gosport"|
                            la_name == "Hart"|
                            la_name == "Havant"|
                            la_name == "New Forest"|
                            la_name == "Portsmouth"|
                            la_name == "Rushmoor"| # northern Hampshire - not always considered part of Solent
                            la_name == "Southampton"|
                            la_name == "Test Valley"|
                            la_name == "Winchester"|
                            la_name == "Isle of Wight", "Solent local authorities", "Other local authorities")
  )
  return(solent)
}

makeFlexTable <- function(df, cap = "caption"){
  # makes a pretty flextable - see https://cran.r-project.org/web/packages/flextable/index.html
  ft <- flextable::flextable(df)
  ft <- colformat_double(ft, digits = 1)
  ft <- fontsize(ft, size = 9)
  ft <- fontsize(ft, size = 10, part = "header")
  ft <- set_caption(ft, caption = cap)
  return(flextable::autofit(ft))
}