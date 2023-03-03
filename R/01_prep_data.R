shp_chi <- read_sf(here('data-raw/Boundaries - Ward Precincts (2023-).geojson')) %>%
  mutate(precinct = as.integer(precinct), ward = as.integer(ward))
mayor_2023 <- readxl::read_excel(here('data-raw/2023-02-28_mayor.xlsx'), skip = 10)

mayor_2023 <- mayor_2023 %>%
  janitor::clean_names() %>%
  mutate(
    ward = ifelse(str_detect(precinct, 'Ward'), str_extract(precinct, '\\d+'), NA_integer_),
    .before = everything()
  )
mayor_2023$ward[1] <- 1L

mayor_2023 <- mayor_2023 %>%
  fill(ward) %>%
  mutate(ward = as.integer(ward)) %>%
  select(-starts_with('percent_')) %>%
  filter(suppressWarnings(!is.na(as.integer(precinct)))) %>%
  mutate(across(everything(), as.integer))

cands <- names(mayor_2023)[-(1:3)]

parties <- tribble(
  ~cand,              ~party, ~short,
  'jamal_green',       'npa', 'gre',
  'sophia_king',       'dem', 'kin',
  'kam_buckner',       'dem', 'buc',
  'willie_l_wilson',   'dem', 'wil',
  'brandon_johnson',   'dem', 'joh',
  'paul_vallas',       'dem', 'val',
  'lori_e_lightfoot',  'dem', 'lig',
  'roderick_t_sawyer', 'dem', 'saw',
  'jesus_chuy_garcia', 'dem', 'gar',
) %>%
  rowwise() %>%
  mutate(key = paste0(party, '_', short),
         last = str_to_title(word(cand, start = -1, sep = '_'))
  )

mayor_2023 <- mayor_2023 %>%
  rename_with(.cols = all_of(cands), .fn = \(x) paste0('may_23_', x)) %>%
  rename_with(.cols = starts_with('may_23_'), .fn = \(x) {
    i <- match(str_sub(x, 8), parties$cand)
    paste0('may_23_', parties$key[i])
    }) %>%
  rename(may_23 = votes)

shp_chi <- shp_chi %>%
  left_join(mayor_2023, by = c('ward', 'precinct'))

shp_chi <- shp_chi %>%
  relocate(ward_precinct, ward, precinct, starts_with('may_23'))

blk <- build_dec('block', 'IL', 'Cook') %>%
  left_join(
    y = pl_get_baf('IL')$INCPLACE_CDP %>%
      rename(GEOID = BLOCKID, place = PLACEFP),
    by = 'GEOID'
  ) %>%
  filter(place == '14000')

st_write(shp_chi, 'data/chicago_2023.geojson')
