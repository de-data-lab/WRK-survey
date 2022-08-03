# WRK Community Survey

A community survey for the WRK Group with a real-time dashboard

## Environment variables

-   `QUALTRICS_API_KEY`: It is available under the Qualtrics' setting menu
-   `QUALTRICS_BASE_URL`: It follows this pattern, `{brand name}.{datacenter name}.qualtrics.com`
-   `QUALTRICS_SURVEY_ID`: The ID of the community survey. Follows this pattern: `SV_********`
-   `PORT`: The port number for the Shiny app

## Get started

### Run the app only

1.  Make sure the `{devtools}` package is installed
2.  In R, run `devtools::load_all(".")`
3.  Then, run \`run_app()\` to start the app

### Test the Docker image

1.  Make sure that you have a Docker installed and running
2.  In Terminal, run `docker build -t wrk-survey .` (you can use any name aside from "wrk-survey") to build the image. It may take a while.
3.  After the image is built, run `docker run --env-file .Renviron -p 80:8080 wrk-survey`.
4.  Your app will be available at `http://127.0.0.1/:80` by default

## How to deploy the app on Heroku

This app is deployed to Heroku using a docker container. A good overview of the process is available in [this repo](https://github.com/virtualstaticvoid/heroku-docker-r#usage). `heroku.yml` tells Heroku to use Dockerfile to build an image

If it's your first time deploy, follow these steps:

1.  Make sure that you have a Heroku account and Heroku CLI installed

2.  In Terminal, run `heroku create --stack=container` to create a Heroku application with the container stack

3.  `git push heroku main` (or `git push heroku your-branch:main`) to deploy the app

### How it works

1.  `heroku.yml` tells Heroku to use Dockerfile to build an image

2.  `Dockerfile` specifies to install `{devtools}` copy everything here to `/src/` folder inside the Docker image

3.  Then, `init.R` is run to install all dependencies specified in the `DESCRIPTION` file. `devtools::install(".")`. Then the image is built.

4.  When the image is run, `/app.R` will be run to get the `PORT` environment variable, load all the files in the package folder (`load_all()`), and run the app with the specified port.

## Note on why we are deploying to Heroku, not Shinyapps.io

This Shiny app is a R package. Unfortunately, it's not possible to deploy a packaged app to Shinyapps.io. This is why the app is deployed to Heroku. 
