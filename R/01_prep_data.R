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
  filter(suppressWarnings(!is.na(as.integer(precinct))))
