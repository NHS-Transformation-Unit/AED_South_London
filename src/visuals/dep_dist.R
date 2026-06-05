
# Borough -----------------------------------------------------------------

# Deprivation band by LAD distribution

plot_dep <- unified_dep_LA_per |>
  pivot_longer(cols = c(Pop_per, Ref_per),
               names_to = "Series",
               values_to = "Percent")

LA_dep <- ggplot(plot_dep, aes(x = `IMD Decile`,
                               y = Percent,
                               fill = Series)) +
  geom_col(position = position_dodge(width = 0.8),
           width = 0.7) +
  geom_errorbar(data = subset(plot_dep, Series == "Ref_per"),
                aes(ymin = Percent - Confidence,
                    ymax = Percent + Confidence),
                position = position_nudge(x = 0.2),
                width = 0.2) +
  facet_wrap(~ `Upper tier local authorities`) +
  scale_fill_manual(name = "Population Group",
                    values = c("Ref_per" = palette_tu[4],
                               "Pop_per" = palette_tu[5]),
                    labels = c("Population",
                               "New referrals")) +
  labs(x = "IMD Decile",
       y = "Percentage",
       title = "Distribution of South London Boroughs referrals compared to the area population",
       subtitle = "Referrals received between May 2023 and April 2026",
       caption = "Source: Mental Health Services Data Set and Office of National Statistics") +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  scale_x_continuous(breaks = seq(1, 10, by = 1)) +
  theme(text = element_text(family = "Franklin Gothic Book"),
        strip.background = element_rect(fill = palette_tu[1]),
        strip.text = element_text(colour = "black", size = 10),
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
        legend.text = element_text(size = 7.5))


# Deprivation band by LA table

LA_dep_tbl <- unified_dep_LA_per |>
  gt() |>
  fmt_percent(columns = c(Pop_per, Ref_per),
              decimals = 1) |>
  cols_hide(columns = Confidence) |>
  cols_label(`Upper tier local authorities` = "Borough",
             `IMD Decile` = "IMD Decile",
             Pop_per = "Population",
             Ref_per = "Referrals") |>
  tab_header(title = "Distribution of South London Boroughs referrals compared to the area population") |>
  tab_style(style = list(cell_fill(color = palette_tu[1])),
            locations = cells_column_labels(everything()))


# South London -------------------------------------------------------------

# Deprivation band for London distribution

plot_LON_dep <- unified_dep_LON_per |>
  pivot_longer(cols = c(Pop_per, Ref_per),
               names_to = "Series",
               values_to = "Percent")

Lon_dep <- ggplot(plot_LON_dep, aes(x = `IMD Decile`,
                                    y = Percent,
                                    fill = Series)) +
  geom_col(position = position_dodge(width = 0.8),
           width = 0.7) +
  geom_errorbar(data = subset(plot_LON_dep, Series == "Ref_per"),
                aes(ymin = Percent - Confidence,
                    ymax = Percent + Confidence),
                position = position_nudge(x = 0.2),
                width = 0.2) +
  scale_fill_manual(name = "Population Group",
                    values = c("Ref_per" = palette_tu[4],
                               "Pop_per" = palette_tu[5]),
                    labels = c("Population",
                               "New referrals")) +
  labs(x = "IMD Decile",
       y = "Percentage",
       title = "Distribution of South London total referrals compared to the area population",
       subtitle = "Referrals received between May 2023 and April 2026",
       caption = "Source: Mental Health Services Data Set and Office of National Statistics") +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  scale_x_continuous(breaks = seq(1, 10, by = 1)) +
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


# Deprivation band for London table

Lon_dep_tbl <- unified_dep_LON_per |>
  gt() |>
  fmt_percent(columns = c(Pop_per,
                          Ref_per),
              decimals = 1) |>
  cols_hide(columns = c(Confidence,
                        `Upper tier local authorities`)) |>
  cols_label(`IMD Decile` = "IMD Decile",
             Pop_per = "Population",
             Ref_per = "Referrals") |>
  tab_header(title = "Distribution of South London total referrals compared to the area population") |>
  tab_style(style = list(cell_fill(color = palette_tu[1])),
            locations = cells_column_labels(everything()))
