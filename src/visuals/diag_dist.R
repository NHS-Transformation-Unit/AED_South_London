
# Diagnosis distribution

ggplot(ref_new_diag, aes(x = reorder(Diagnosis,Diagnosed),
                         y = Diagnosed,
                         fill = colour)) +
  geom_col() +
  scale_fill_identity() +
  labs(x = "Diagnosis description",
       y = "Number of diagnoses",
       title = "South London") +
  theme(selected_theme(palette_tu[1]))
