# build the quarto doc
library(quarto)

# run report ----
quarto_render(input = here::here("qmd","hampshire-ghg-co2e.qmd")
              )


# save to docs for github pages ----
file.copy(from = here::here("qmd","hampshire-ghg-co2e.html"), 
          to = here::here("docs","hampshire-ghg-co2e.html"), overwrite = TRUE
)