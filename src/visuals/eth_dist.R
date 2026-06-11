
# Borough -----------------------------------------------------------------

plot_LA_eth <- function(df, borough) {

# Ethnic group by LAD distribution

plot_eth <- df |>
  filter(`Upper tier local authorities` == borough) |>
  pivot_longer(cols = c(Pop_per, Ref_per),
               names_to = "Series",
               values_to = "Percent")

ggplot(plot_eth, aes(x = `Ethnic group (8 categories)`,
                     y = Percent,
                     fill = Series)) +
  geom_col(position = position_dodge(width = 0.8),
           width = 0.7) +
  geom_errorbar(data = subset(plot_eth, Series == "Ref_per"),
                aes(ymin = Percent - Confidence,
                    ymax = Percent + Confidence),
                position = position_nudge(x = 0.2),
                width = 0.2) +
  scale_fill_manual(name = "Population Group",
                    values = c("Ref_per" = palette_tu[6],
                               "Pop_per" = palette_tu[7]),
                    labels = c("Population",
                               "New referrals")) +
  labs(x = "Ethnic group",
       y = "Percentage",
       title = paste0("Distribution of ", borough," referrals compared to the area population"),
       subtitle = "Referrals received between May 2023 and April 2026",
       caption = "Source: Mental Health Services Data Set and Office of National Statistics") +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1),
                     breaks = seq(0, 0.8, by = 0.1)) +
  scale_x_discrete(labels = function(Diagnosis) str_wrap(Diagnosis, width = 40)) +
  theme(text = element_text(family = "Franklin Gothic Book"),
        strip.background = element_rect(fill = palette_tu[1]),
        strip.text = element_text(colour = "black", size = 10),
        axis.text = element_text(size = 8),
        axis.text.x = element_text(angle = 0, vjust = 0.5, hjust = 1),
        axis.title = element_text(size = 10),
        plot.title = element_text(size = 12, color = palette_tu[1]),
        plot.subtitle = element_text(size = 10),
        panel.background = element_rect(fill = "#ffffff"),
        panel.grid.major.y = element_line(color = "#cecece", linewidth = 0.1),
        panel.grid.minor.y = element_blank(),
        axis.line = element_line(color = "#000000"),
        legend.position = "bottom",
        legend.text = element_text(size = 7.5)) +
  coord_flip()
}

# Ethnic group by LA table

LA_eth_tbl <- unified_eth_LA_per |>
  ungroup() |>
  select(`Upper tier local authorities`,
         `Ethnic group (8 categories)`,
         Pop_per,
         Ref_per) |>
  rename(Borough = `Upper tier local authorities`,
         `Ethnic group` = `Ethnic group (8 categories)`,
         Population = Pop_per,
         Referrals = Ref_per) |>
  datatable(caption = "Distribution of South London Boroughs referrals compared to the area population",
            rownames = FALSE,
            options = list(initComplete = JS(sprintf("function(settings, json) {
                                                                                $(this.api().table().header()).find('th').css({
                                                                                'background-color': '%s',
                                                                                'color': 'white'
                                                                                });
                                                     }",
                                                     palette_tu[1])))) |>
  formatPercentage(columns = c("Population",
                               "Referrals"),
                   digits = 1)


# South London ------------------------------------------------------------

# Age band for London distribution

plot_LON_eth <- unified_eth_LON_per |>
  pivot_longer(cols = c(Pop_per, Ref_per),
               names_to = "Series",
               values_to = "Percent")

Lon_eth <- ggplot(plot_LON_eth, aes(x = `Ethnic group (8 categories)`,
                                    y = Percent,
                                    fill = Series)) +
  geom_col(position = position_dodge(width = 0.8),
           width = 0.7) +
  geom_errorbar(data = subset(plot_LON_eth, Series == "Ref_per"),
                aes(ymin = Percent - Confidence,
                    ymax = Percent + Confidence),
                position = position_nudge(x = 0.2),
                width = 0.2) +
  scale_fill_manual(name = "Population Group",
                    values = c("Ref_per" = palette_tu[6],
                               "Pop_per" = palette_tu[7]),
                    labels = c("Population",
                               "New referrals")) +
  labs(x = "Ethnic group",
       y = "Percentage",
       title = "Distribution of South London total referrals compared to the area population",
       subtitle = "Referrals received between May 2023 and April 2026",
       caption = "Source: Mental Health Services Data Set and Office of National Statistics") +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  scale_x_discrete(labels = function(Diagnosis) str_wrap(Diagnosis, width = 35)) +
  theme(text = element_text(family = "Franklin Gothic Book"),
        axis.text = element_text(size = 10),
        axis.text.x = element_text(angle = 0, vjust = 0.5, hjust = 1),
        axis.title = element_text(size = 10),
        plot.title = element_text(size = 12, color = palette_tu[1]),
        plot.subtitle = element_text(size = 10),
        panel.background = element_rect(fill = "#ffffff"),
        panel.grid.major.y = element_line(color = "#cecece", linewidth = 0.1),
        panel.grid.minor.y = element_blank(),
        axis.line = element_line(color = "#000000"),
        legend.position = "bottom",
        legend.text = element_text(size = 7.5)) +
  coord_flip()


# Ethnic group for London table

Lon_eth_tbl <- unified_eth_LON_per |>
  ungroup() |>
  select(`Ethnic group (8 categories)`,
         Pop_per,
         Ref_per) |>
  rename(`Ethnic group` = `Ethnic group (8 categories)`,
         Population = Pop_per,
         Referrals = Ref_per) |>
  datatable(caption = "Distribution of South London referrals compared to the area population",
            rownames = FALSE,
            options = list(initComplete = JS(sprintf("function(settings, json) {
                                                                                $(this.api().table().header()).find('th').css({
                                                                                'background-color': '%s',
                                                                                'color': 'white'
                                                                                });
                                                     }",
                                                     palette_tu[1])))) |>
  formatPercentage(columns = c("Population",
                               "Referrals"),
                   digits = 1)