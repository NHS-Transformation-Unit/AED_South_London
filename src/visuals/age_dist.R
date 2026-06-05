
# Age band by LAD distribution

plot_age <- unified_age_LA_per |>
  pivot_longer(cols = c(Pop_per, Ref_per),
               names_to = "Series",
               values_to = "Percent")

LA_age <- ggplot(plot_age, aes(x = Age_band,
                               y = Percent,
                               fill = Series)) +
  geom_col(position = position_dodge(width = 0.8),
           width = 0.7) +
  geom_errorbar(data = subset(plot_age, Series == "Ref_per"),
                aes(ymin = Percent - Confidence,
                    ymax = Percent + Confidence),
                position = position_nudge(x = 0.2),
                width = 0.2) +
  facet_wrap(~ `Upper tier local authorities`) +
  scale_fill_manual(name = "Population Group",
                    values = c("Ref_per" = palette_tu[2],
                               "Pop_per" = palette_tu[3]),
                    labels = c("Population",
                               "New referrals")) +
  labs(x = "Age band",
       y = "Percentage",
       title = "Distribution of South London Boroughs referrals compared to the area population",
       subtitle = "Referrals received between May 2023 and April 2026",
       caption = "Source: Mental Health Services Data Set and Office of National Statistics") +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  scale_x_discrete(labels = function(Diagnosis) str_wrap(Diagnosis, width = 20)) +
  theme(selected_theme(palette_tu[1]),
        legend.position = "bottom")


# Age band for London distribution

plot_LON_age <- unified_age_LON_per |>
  pivot_longer(cols = c(Pop_per, Ref_per),
               names_to = "Series",
               values_to = "Percent")

Lon_age <- ggplot(plot_LON_age, aes(x = Age_band,
                                    y = Percent,
                                    fill = Series)) +
  geom_col(position = position_dodge(width = 0.8),
           width = 0.7) +
  geom_errorbar(data = subset(plot_LON_age, Series == "Ref_per"),
                aes(ymin = Percent - Confidence,
                    ymax = Percent + Confidence),
                position = position_nudge(x = 0.2),
                width = 0.2) +
  scale_fill_manual(name = "Population Group",
                    values = c("Ref_per" = palette_tu[2],
                               "Pop_per" = palette_tu[3]),
                    labels = c("Population",
                               "New referrals")) +
  labs(x = "Age band",
       y = "Percentage",
       title = "Distribution of South London total referrals compared to the area population",
       subtitle = "Referrals received between May 2023 and April 2026",
       caption = "Source: Mental Health Services Data Set and Office of National Statistics") +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  theme(selected_theme(palette_tu[1]),
        legend.position = "bottom") +
  coord_flip()

