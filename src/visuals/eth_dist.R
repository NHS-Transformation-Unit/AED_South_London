
# Ethnic group by LAD distribution

plot_eth <- unified_eth_LA_per |>
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
  facet_wrap(~ `Upper tier local authorities`) +
  scale_fill_manual(name = "Population Group",
                    values = c("Ref_per" = palette_tu[6],
                               "Pop_per" = palette_tu[7]),
                    labels = c("Borough population distribution",
                               "New referrals")) +
  labs(x = "Ethnic group",
       y = "Percentage",
       title = "South London Boroughs") +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  theme(selected_theme(palette_tu[1]))



# Age band for London distribution

plot_LON_eth <- unified_eth_LON_per |>
  pivot_longer(cols = c(Pop_per, Ref_per),
               names_to = "Series",
               values_to = "Percent")

ggplot(plot_LON_eth, aes(x = `Ethnic group (8 categories)`,
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
                    labels = c("South London population distribution",
                               "New referrals")) +
  labs(x = "Ethnic group",
       y = "Percentage",
       title = "South London total") +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  theme(selected_theme(palette_tu[1]))

