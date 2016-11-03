#' create a shiny server to be wired up to sliders 
#' @param mod model parameter
#' @param shiny_param_list list of param and initial values
#' @details 
#' shiny_param_list comes from as.list(param(mod)) and any
#' prior filtering. Any passed in will expect to be modifying
#' the values from the slider inputs
#' @importFrom dplyr bind_cols mutate_    
#' @importFrom mrgsolve mrgsim
#' @export
make_server <- function(mod, shiny_param_list) {
  return(function(input, output, session) {
    idata <- shiny_param_list %>% bind_cols() 
    param_names <- names(shiny_param_list)
    nidata <- reactive({
      dots <- lapply(param_names, function(param) {
        as.numeric(input[[param]])
      })
      idata %>% mutate_(.dots = setNames(dots, param_names))
    })
    output$default_plot <- renderPlot({
      print(nidata())
      mod %>% 
        mrgsim(idata = nidata()) %>% 
        plot
    })
    
    
  })
}    

