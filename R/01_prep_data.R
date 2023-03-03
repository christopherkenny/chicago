shp_chi <- read_sf(here('data-raw/Boundaries - Ward Precincts (2012-2022).geojson'))
mayor_2023 <- readxl::read_excel(here('data-raw/2023-02-28_mayor.xlsx'), skip = 10)

mayor_2023 <- mayor_2023 %>%
  janitor::clean_names() %>%
  mutate(
    ward = ifelse(str_detect(precinct, 'Ward'), str_extract(precinct, '\\d+'), NA_integer_),
    .before = everything()
  )
mayor_2023$ward[1] <- 1L

mayor_2023 <- mayor_2023 %>%
  fill(ward)

mayor_2023 %>%
  rename_with(.fn = \(x) {
    i <- match(x, names(mayor_2023))
    str_replace(x, '\\d+', names(mayor_2023)[i - 1L])
  }, .cols = starts_with('percent_')) %>%
  mutate(across(starts_with('percent_'), as.numeric))
