#' Net promoter score UI module
#'
#' @param id element ID
#'
#' @return a `div` tag object
#' @export
#'
#' @examples
#' net_promoter_score_UI("nps")
net_promoter_score_UI <- function(id) {
  shiny::withTags(
    shiny::tagList(
      div(class = "d-flex flex-column align-items-center",
          h1(class = "text-center fw-bold",
             "Net Promoter Score"),
          div(class = "my-3 fs-5",
              style = "max-width: 30rem",
              "How likely are you to recommend this community to someone else as a good place to live?"),
          div(
            plotly::plotlyOutput(shiny::NS(id, "plot"), width = "400px"),
            align = "center"
          )
      ),
      div(id = "vertical-bar-container",
          hr(),
          h3("Breakdown", class = "text-center"),
          div(
            plotly::plotlyOutput(shiny::NS(id, "vertical_plot"), width = "400px"),
            align = "center"
          ))
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
#' \dontrun{
#' net_promoter_score_server("nps", data = get_survey_data())
#' }
net_promoter_score_server <- function(id, data) {
  shiny::moduleServer(id, function(input, output, session) {

    output$plot <- plotly::renderPlotly(
      {
        nps_summary <- data %>%
          dplyr::count(recommend_2gp) %>%
          dplyr::mutate(prop = n / sum(n)) %>%
          dplyr::mutate(color = dplyr::case_when(recommend_2gp == "Would recommend" ~ "#00A454",
                                                 recommend_2gp == "Would NOT recommend" ~ "#494F56"))

        question_categories <- data %>%
          dplyr::pull(recommend)

        # Prepare the center annotation
        would_recommend_prop <- nps_summary %>%
          dplyr::filter(recommend_2gp == "Would recommend") %>%
          dplyr::pull(prop)

        # Prepare hovertext
        nps_summary <- nps_summary %>%
          dplyr::mutate(hovertext_abbr = dplyr::case_when(recommend_2gp == "Would recommend" ~ "would or probably would",
                                                          recommend_2gp == "Would NOT recommend" ~ "would NOT or probably would NOT"))
        nps_summary <- nps_summary %>%
          dplyr::mutate(hovertext = paste0(
            round(prop * 100, 1), "% ",
            "of participants answered that they ",
            hovertext_abbr,
            " recommend this community to someone else as a good place to live"
          )) %>%
          # Add line breaks
          dplyr::mutate(hovertext = stringr::str_wrap(hovertext, 25))

        nps_summary %>%
          plotly::plot_ly(values = ~prop,
                          marker = list(colors = ~color),
                          textinfo = "none",
                          customdata  = ~tolower(recommend_2gp),
                          hoverinfo = "text",
                          hovertext = ~hovertext) %>%
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

    output$vertical_plot <- plotly::renderPlotly({
      vertical_bar_summary <- data %>%
        dplyr::count(recommend) %>%
        dplyr::mutate(prop = n / sum(n))


      dplyr::glimpse(vertical_bar_summary)

      # Prepare the annotations
      vertical_bar_summary <- vertical_bar_summary %>%
        # Set abbreviation for annotation
        dplyr::mutate(recommend_abbr = dplyr::case_when(
          recommend == "Definitely would recommend" ~ "Definitely",
          recommend == "Probably would recommend" ~ "Probably",
          recommend == "Definitely would NOT recommend" ~ "Definitely NOT",
          recommend == "Probably would NOT recommend" ~ "Probably NOT"
        )) %>%
        dplyr::mutate(annotation = paste0(
          round(prop * 100, 1), "% ", recommend_abbr
        ))

      # Prepare the hovertext texts
      vertical_bar_summary <- vertical_bar_summary %>%
        dplyr::mutate(hovertext = paste0(
          round(prop * 100, 1), "% ",
          "of participants answered that they would ",
          tolower(recommend_abbr),
          " this community to someone else as a good place to live"
        )) %>%
        # Add line breaks to hover text
        dplyr::mutate(hovertext = stringr::str_wrap(hovertext, width = 25))

      # Calculate the positions for the annotations
      vertical_bar_summary <- vertical_bar_summary %>%
        dplyr::arrange(recommend) %>%
        dplyr::mutate(y_pos_annotation = cumsum(prop) - (prop / 2))

      # Set colors for the vertical bar
      vbar_colors <- c("#494F56", "#A6A6A6",
                       "#00A454", "#00CF6A")
      question_categories <- data %>%
        dplyr::pull(recommend)
      # Add color column
      vertical_bar_summary <- vertical_bar_summary %>%
        dplyr::mutate(color = vbar_colors)

      # Create the vertical plot
      vertical_bar_summary %>%
        plotly::plot_ly(y = ~prop,
                        x = 1,
                        color = ~I(color),
                        hoverinfo = "text",
                        hovertext = ~hovertext) %>%
        plotly::add_bars() %>%
        plotly::layout(barmode = "stack") %>%
        # Add annotations
        plotly::add_annotations(text = ~annotation,
                                x = 1.5,
                                y = ~y_pos_annotation,
                                showarrow = FALSE,
                                font = list(size = 16),
                                xanchor = "left") %>%
        # Remove axis labels
        plotly::layout(yaxis = list(title = ""),
                       xaxis = list(title = "")) %>%
        # Remove ticks and grids
        plotly::layout(yaxis = list(showticklabels = FALSE,
                                    showgrid = FALSE,
                                    zeroline = FALSE),
                       xaxis = list(showticklabels = FALSE,
                                    showgrid = FALSE)) %>%
        # Hide Legend
        plotly::hide_legend() %>%
        # Remove mode bar
        plotly::config(displayModeBar = FALSE) %>%
        # Disable the click
        plotly::layout(legend = list(itemclick = FALSE, itemdoubleclick = FALSE)) %>%
        # Disable zoom
        plotly::layout(xaxis = list(fixedrange = TRUE),
                       yaxis = list(fixedrange = TRUE))



    })

  })
}




