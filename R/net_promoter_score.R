#' Net promoter score UI module
#'
#' @param id
#'
#' @return a `div` tag object
#' @export
#'
#' @examples
#' net_promoter_score_UI("nps")
net_promoter_score_UI <- function(id) {
  shiny::withTags(
    div(class = "d-flex flex-column align-items-center",
        h1(class = "text-center",
           "Net Promoter Score"),
        div(class = "text-secondary my-3",
            style = "max-width: 30rem",
            "How likely are you to recommend this community to someone else as a good place to live?"),
        div(
          plotly::plotlyOutput(shiny::NS(id, "plot"), width = "400px"),
          align = "center"
        )
    )
  )
}

#' Net promoter score server module
#'
#' @param id element ID
#' @param data survey responses data
#'
#' @return shiny output
#' @export
#'
#' @examples
#' net_promoter_score_server("nps")
net_promoter_score_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {

    output$plot <- plotly::renderPlotly(
      {
        nps_summary <- data %>%
          dplyr::count(recommend_2gp) %>%
          dplyr::mutate(prop = n / sum(n)) %>%
          dplyr::mutate(color = dplyr::case_when(recommend_2gp == "Would recommend" ~ "#00A454",
                                                 recommend_2gp == "Would NOT recommend" ~ "#494F56"))

        would_recommend_prop <- nps_summary %>%
          dplyr::filter(recommend_2gp == "Would recommend") %>%
          dplyr::pull(prop)

        nps_summary %>%
          plotly::plot_ly(values = ~prop,
                          marker = list(colors = ~color),
                          textinfo = "none") %>%
          plotly::add_pie(hole = 0.6) %>%
          plotly::layout(showlegend = F,
                         margin = list(l = 20, r = 20)) %>%
          plotly::config(displayModeBar = FALSE) %>%
          plotly::add_annotations(text = sprintf("%.1f%%", would_recommend_prop * 100),
                                  showarrow = FALSE,
                                  font = list(size = 50)) %>%
          plotly::add_annotations(text = "Would Recommend",
                                  x = 1.05,
                                  y = -0.03,
                                  showarrow = FALSE,
                                  font = list(size = 15)) %>%
          plotly::add_annotations(text = "Not",
                                  x = 0.10,
                                  y = 0.95,
                                  showarrow = FALSE,
                                  font = list(size = 15))
      }
    )

  })
}




