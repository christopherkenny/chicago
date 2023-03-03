shp <- shp_chi %>%
  rowwise() %>%
  mutate(
    prec_share = max(c_across(starts_with('may_23_'))) / may_23,
    prec_win = str_sub(colnames(.)[5:13][which.max(c_across(starts_with('may_23_')))], 8)
  ) %>%
  ungroup() %>%
  mutate(prec_win = parties$last[match(prec_win, parties$key)])

shp %>%
  ggplot() +
  geom_sf(aes(alpha = prec_share, fill = prec_win), color = NA) +
  scale_fill_wa_d(name = 'Candidate', palette = 'skagit') +
  scale_alpha_continuous(name = 'Share') +
  theme_map() +
  theme(legend.position = c(0.2, 0.25))
