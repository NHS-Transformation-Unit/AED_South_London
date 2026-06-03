
# Deprivation band by LAD distribution

plot_dep <- unified_dep_LA_per |>
  pivot_longer(cols = c(Pop_per, Ref_per),
               names_to = "Series",
               values_to = "Percent")

ggplot(plot_dep, aes(x = `IMD Decile`,
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
                    labels = c("Borough population distribution",
                               "New referrals")) +
  labs(x = "IMD Decile",
       y = "Percentage",
       title = "South London Boroughs") +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  scale_x_continuous(limits = c(1,10), breaks = 1:10) +
  scale_x_discrete(labels = function(Diagnosis) str_wrap(Diagnosis, width = 20)) +
  theme(selected_theme(palette_tu[1]),
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))


# Deprivation band for London distribution

plot_LON_dep <- unified_dep_LON_per |>
  pivot_longer(cols = c(Pop_per, Ref_per),
               names_to = "Series",
               values_to = "Percent")

ggplot(plot_LON_dep, aes(x = `IMD Decile`,
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
                    labels = c("South London population distribution",
                               "New referrals")) +
  labs(x = "IMD Decile",
       y = "Percentage",
       title = "South London total") +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  scale_x_continuous(limits = c(1,10), breaks = 1:10) +
  scale_x_discrete(labels = function(Diagnosis) str_wrap(Diagnosis, width = 20)) +
  theme(selected_theme(palette_tu[1]),
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))

