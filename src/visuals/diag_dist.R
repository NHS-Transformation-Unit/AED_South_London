
# Diagnosis distribution

Ref_diag <- ggplot(ref_new_diag, aes(x = reorder(Diagnosis,Diagnosed),
                                     y = Diagnosed,
                                     fill = colour)) +
  geom_col() +
  scale_fill_identity() +
  scale_x_discrete(labels = function(Diagnosis) str_wrap(Diagnosis, width = 20)) +
  labs(x = "Diagnosis description",
       y = "Number of diagnoses",
       title = "Diagnosis received for all patients referred",
       subtitle = "Referrals received between May 2023 and April 2026",
       caption = "Source: Mental Health Services Data Set") +
  theme(selected_theme(palette_tu[1]))
