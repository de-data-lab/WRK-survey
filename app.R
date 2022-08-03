# This script is used for deployment only
port <- Sys.getenv("PORT")

devtools::load_all(".")
shiny::runApp(run_app(),
              host = '0.0.0.0',
              port = as.numeric(port))
