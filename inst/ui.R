
library(shiny)
source("bin_params.R")
make_ui <- function(param_list, params_per_tab = 6) {
  param_list_split <- data.frame(
    param_names = names(param_list),
    tab_num = bin_params(names(param_list), params_per_tab)
    ) %>% split(.$tab_num) %>% lapply(function(param_index) {
      return(as.character(param_index$param_names))
    })
  tab_params <- lapply(seq_along(param_list_split), function(i) {
                tabPanel(paste0("P", i),
                         br(),
                         lapply(param_list_split[[i]], function(param) {
                           val <- param_list[[param]]
                           step <- ifelse(val < 5, ifelse(val < 1, 0.1, 0.25), 1)
                           sliderInput(param,
                                       param,
                                       value = val,
                                       min = val/10+step, #so min value 0
                                       max = val*5,
                                       step = step)
                         }),
                         br()
                )
              })
  return(fluidPage(
  # Application title
  titlePanel("mrgexplore"),
  fluidPage(
    fluidRow(
      column(3,
             do.call(tabsetPanel, tab_params)),
      column(9,
             plotOutput("default_plot")
             )
    )
  )
))}
