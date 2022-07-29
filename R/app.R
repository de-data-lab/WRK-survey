#' Run The WRK Survey App
#'
#' @param ... parameters passed to `shiny::shinyApp()`
#'
#' @return an app
#' @export
#'
#' @examples
#' run_app()
run_app <- function(...){

  WRK_logo <- system.file("logo.png",
                          package = packageName())
  shiny::addResourcePath("logo", WRK_logo)

  styles <- system.file("styles.css",
                        package = packageName())

  # UI
  ui <- shiny::bootstrapPage(
    # Import CSS
    shiny::includeCSS(styles),
    theme = bslib::bs_theme(version = 5,
                            "WRK-navy-blue" = "#123c63",
                            "WRK-green" = "#00a454") %>%
      bslib::bs_theme_update(primary = "#00a454",
                             secondary = "#123c63",
                             info = "white",
                             font_scale = NULL,
                             bootswatch = "flatly"),
    # Navbar
    navbar_UI("navbar", logo = "logo"),

    # Body of the page
    shiny::withTags(
      # Render Card
      div(class = "d-flex flex-column flex-lg-row container",
          div(class = "container card border-light bg-info m-2",
              div(class = "card-body",
                  net_promoter_score_UI("nps")
              )
          ),
      ),
    )
  )

  # Server
  server <- function(input, output, session) {
    # Get Data
    responses <- get_survey_data()

    # Update the responses dataset
    # Add two groups for the net promoter scores
    responses <- responses %>%
      dplyr::mutate(recommend_2gp = dplyr::case_when(
        recommend %in% c("Definitely would recommend", "Probably would recommend") ~ "Would recommend",
        recommend %in% c("Probably would NOT recommend", "Definitely would NOT recommend") ~ "Would NOT recommend"))

    # Net promoter scores - server function
    net_promoter_score_server("nps", data = responses)
  }

  # Render the app
  shiny::shinyApp(ui, server, ...)
}
