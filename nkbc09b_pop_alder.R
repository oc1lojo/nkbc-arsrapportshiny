GLOBALS <- defGlobals(
  LAB = "Ålder vid diagnos",
  SHORTLAB = "Ålder",
  POP = "alla anmälda fall.",
  SJHKODUSE = "a_inr_sjhkod"
)

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    outcome = a_pat_alder
  ) %>%
  filter(
    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, d_invasiv)

rccShiny(
  data = dftemp,
  folder = "nkbc09b",
  path = OUTPUTPATH,
  outcomeTitle = GLOBALS$LAB,
  folderLinkText = GLOBALS$SHORTLAB,
  geoUnitsPatient = FALSE,
  textBeforeSubtitle = GLOBALS$SHORTPOP,
  description = c(
    "Det är ovanligt med bröstcancer i unga år.",
    paste(
      descTolk,
      sep = str_sep_description
    ),
    paste(
      descTekBes(),
      sep = str_sep_description
    )
  ),
  varOther = list(
    list(
      var = "d_invasiv",
      label = c("Invasivitet vid diagnos")
    )
  ),
  propWithinUnit = "år",
  propWithinValue = 65
)
