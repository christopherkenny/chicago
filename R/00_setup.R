suppressMessages({
  # general ----
  library(tidyverse)
  library(fs)
  library(here)
  library(cli)
  #library(gt)
  library(readxl)

  # geospatial ----
  library(sf)

  # alarm project ----
  #library(redist)
  library(geomander)
  library(censable)
  #library(tinytiger)
  library(ggredist)
  #library(alarmdata)
  library(PL94171)

  # plotting ----
  library(wacolors)
  library(patchwork)
  library(scales)
})

#walk(dir_ls(path = here('R/utils/'), glob = '*.R'), source)

cli_alert_success('Packages loaded and utilities prepared.')
