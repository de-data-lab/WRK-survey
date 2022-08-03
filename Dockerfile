FROM rocker/shiny-verse:4.1.1
# Specify port
ENV PORT=8080
# Install devtools
RUN install2.r devtools
# Copy all the files here into /src/
COPY . /src/
# Set /src/ as the working directory
WORKDIR /src/
# Install dependencies
RUN Rscript init.R
# Set port options
CMD ["R", "-e", "options(shiny.port = 8080)"]
# Start app
CMD Rscript app.R
