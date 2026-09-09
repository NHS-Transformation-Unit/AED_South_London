
downloadable_plot <- function(
    plot = NULL,
    data = NULL,
    plot_function = NULL,
    plot_args = list(),
    name = "plot",
    width = 8,
    height = 6,
    dpi = 300
) {
  
  # --------------------------------------------------
  # Create the plot
  # --------------------------------------------------
  
  if (!is.null(plot_function)) {
    
    p <- do.call(
      plot_function,
      plot_args
    )
    
  } else if (!is.null(plot)) {
    
    p <- plot
    
  } else {
    
    stop(
      "Provide either 'plot' or 'plot_function'."
    )
  }
  
  
  # --------------------------------------------------
  # Create downloads directory
  # --------------------------------------------------
  
  dir.create(
    "downloads",
    showWarnings = FALSE
  )
  
  
  # --------------------------------------------------
  # Create temporary PNG
  # --------------------------------------------------
  
  png_file <- tempfile(
    fileext = ".png")
  
  ggplot2::ggsave(
    filename = png_file,
    plot = p,
    width = width,
    height = height,
    dpi = dpi
  )
  
  # --------------------------------------------------
  # Convert PNG to embedded URI
  # --------------------------------------------------
  
  png_uri <- base64enc::dataURI(
    file = png_file,
    mime = "image/png"
  )
  
  
  # --------------------------------------------------
  # Convert data to embedded CSV
  # --------------------------------------------------
  
  csv_uri <- NULL
  
  if (!is.null(data)) {
    
    csv_file <- tempfile(
      fileext = ".csv"
    )
    
    utils::write.csv(
      data,
      csv_file,
      row.names = FALSE
    )
    
    csv_uri <- base64enc::dataURI(
      file = csv_file,
      mime = "text/csv"
    )
  }
  
  
  # --------------------------------------------------
  # Display plot
  # --------------------------------------------------
  
  print(p)
  
  
  # --------------------------------------------------
  # Download buttons
  # --------------------------------------------------
  
  html <- paste0(
    '<div class="download-buttons">',
    
    '<a href="',
    png_uri,
    '" download="',
    name,
    '.png">',
    '<button type="button">',
    'Download PNG',
    '</button>',
    '</a>',
    
    if (!is.null(data)) {
      paste0(
        '<a href="',
        csv_uri,
        '" download="',
        name,
        '.csv">',
        '<button type="button">',
        'Download data',
        '</button>',
        '</a>'
      )
    } else {
      ""
    },
    
    '</div>'
  )
  
  knitr::asis_output(html)
}
