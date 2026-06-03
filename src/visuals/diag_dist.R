
# Diagnosis distribution

ggplot(ref_new_diag, aes(x = reorder(Diagnosis,Diagnosed),
                         y = Diagnosed,
                         fill = colour)) +
  geom_col() +
  scale_fill_identity() +
  scale_x_discrete(labels = function(Diagnosis) str_wrap(Diagnosis, width = 20)) +
  labs(x = "Diagnosis description",
       y = "Number of diagnoses",
       title = "South London") +
  theme(selected_theme(palette_tu[1]),
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
