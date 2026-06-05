
# Diagnosis distribution

Ref_diag <- ggplot(ref_new_diag, aes(x = reorder(Diagnosis,Diagnosed),
                                     y = Diagnosed,
                                     fill = colour)) +
  geom_col() +
  scale_fill_identity() +
  scale_y_discrete(labels = function(Diagnosis) str_wrap(Diagnosis, width = 20)) +
  labs(x = "Diagnosis description",
       y = "Number of diagnoses",
       title = "Diagnosis received for all patients referred",
       subtitle = "Referrals received between May 2023 and April 2026",
       caption = "Source: Mental Health Services Data Set") +
  theme(text = element_text(family = "Franklin Gothic Book"),
        axis.text = element_text(size = 10),
        axis.text.x = element_text(angle = 0, vjust = 0.5, hjust = 1),
        axis.title = element_text(size = 11),
        plot.title = element_text(size = 16, color = palette_tu[1]),
        plot.subtitle = element_text(size = 12),
        panel.background = element_rect(fill = "#ffffff"),
        panel.grid.major.y = element_line(color = "#cecece", linewidth = 0.1),
        panel.grid.minor.y = element_blank(),
        axis.line = element_line(color = "#000000"),
        legend.position = "bottom",
        legend.text = element_text(size = 7.5)) +
  coord_flip()


# Diagnosis table

ref_diag_tbl <- ref_new_diag |>
  gt() |>
  tab_header(title = "Diagnosis of referrals") |>
  tab_style(style = list(cell_fill(color = palette_tu[1])),
            locations = cells_column_labels(everything()))
