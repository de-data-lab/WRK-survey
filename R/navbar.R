navbar_UI <- function(id, logo) {
  # Navbar
  shiny::tagList(
    shiny::withTags(
      nav(class = "navbar navbar-dark bg-primary sticky-top",
          div(class = "container-fluid",
              button(class = "btn",
                     type = "button",
                     "data-bs-toggle" = "offcanvas",
                     "data-bs-target" = "#offcanvasNavbar",
                     "aria-controls" = "offcanvasNavbar",
                     "aria-expanded" = "false",
                     span(class = "navbar-toggler-icon")),
              a(class = "navbar-brand",
                href = "https://wrkgroup.org/",
                target = "_blank",
                img(src = logo, class = "img-fluid",
                    alt = "A logo of The WRK Group",
                    width = "30",
                    height = "24")),
          )
      )
    ),

    # Offcanvas (the menu drawer to the left)
    shiny::withTags(
      div(class = "offcanvas offcanvas-start bg-secondary",
          tabindex = "-1",
          id = "offcanvasNavbar",
          "aria-labelledby" = "offcanvasNavbarLabel",
          div(class = "offcanvas-header",
              h5(class = "offcanvas-title",
                 id = "offcanvasNavbarLabel",
                 "Community Survey Dashboard"),
              button(type = "button",
                     class = "btn-close text-reset",
                     "data-bs-dismiss" = "offcanvas",
                     "aria-label" = "Close")),
          div(class = "offcanvas-body",
              ul(class = "navbar-nav justify-content-end flex-grow-1 pe-1 mx-2",
                 li(class = "nav-item",
                    a(class = "nav-link active",
                      "aria-current" = "page",
                      href = "#",
                      "Home")),
                 li(class = "nav-item",
                    a(class = "nav-link active",
                      "aria-current" = "page",
                      href = "#",
                      "About")),
                 li(class = "nav-item",
                    a(class = "nav-link",
                      href = "https://github.com/de-data-lab/WRK-survey",
                      target = "_blank",
                      shiny::icon("github", class = "text-white fs-2"))))
          )
      )
    )
  )
}

navbar_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  })
}
