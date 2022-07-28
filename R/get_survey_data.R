#' Get the survey data from a survey with the survey ID
#'
#' Get the survey data from a survey specified by the survey ID. The function requires that the
#'
#' @param survey_id Survey ID. By default, it uses `QUALTRICS_SURVEY_ID` in the environment variable.
#'
#' @return A tibble of survey responses
#' @export
#'
#' @examples
#' responses <- get_survey_data()
get_survey_data <- function(survey_id = Sys.getenv("QUALTRICS_SURVEY_ID")) {
  # Check if the API Key and the base URL environment variables are set
  if(Sys.getenv("QUALTRICS_API_KEY") == "") return(
    stop("The environment variable: QUALTRICS_API_KEY is not found in the .Renviron file. Set this environment variable and restart your R session.")
  )
  if(Sys.getenv("QUALTRICS_BASE_URL") == "") return(
    stop("The environment variable: QUALTRICS_BASE_URL is not found in the .Renviron file. Set this environment variable and restart your R session.")
  )

  # Fetch survey responses
  qualtRics::fetch_survey(survey_id,
                          force_request = TRUE,
                          convert = FALSE)
}
