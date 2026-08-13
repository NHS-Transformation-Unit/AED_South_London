
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
  # Save PNG
  # --------------------------------------------------
  
  png_file <- file.path(
    "downloads",
    paste0(name, ".png")
  )
  
  ggplot2::ggsave(
    filename = png_file,
    plot = p,
    width = width,
    height = height,
    dpi = dpi
  )
  
  
  # --------------------------------------------------
  # Save data
  # --------------------------------------------------
  
  if (!is.null(data)) {
    
    csv_file <- file.path(
      "downloads",
      paste0(name, ".csv")
    )
    
    utils::write.csv(
      data,
      csv_file,
      row.names = FALSE
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
    
    '<a href="downloads/',
    name,
    '.png" download>',
    '<button type="button">',
    'Download PNG',
    '</button>',
    '</a>',
    
    if (!is.null(data)) {
      paste0(
        '<a href="downloads/',
        name,
        '.csv" download>',
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
