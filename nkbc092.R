NAME <- "nkbc092"

GLOBALS <- defGlobals(
  LAB = "Ålder vid diagnos",
  SHORTLAB = "Ålder",
  POP = "alla anmälda fall.",
  SJHKODUSE <- "a_inr_sjhkod"
)

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    outcome = a_pat_alder
  ) %>%
  filter(
    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, invasiv)


link <- rccShiny(
  data = dftemp,
  folder = NAME,
  path = OUTPUTPATH,
  outcomeTitle = GLOBALS$LAB,
  folderLinkText = GLOBALS$SHORTLAB,
  geoUnitsPatient = FALSE,
  textBeforeSubtitle = GLOBALS$SHORTPOP,
  description = c(
    "Det är ovanligt med bröstcancer i unga år.",
    descTolk,
    descTekBes()
  ),
  varOther = list(
    list(
      var = "invasiv",
      label = c("Invasivitet vid diagnos")
    )
  ),
  propWithinUnit = "år",
  propWithinValue = 65
)

cat(link)
# runApp(paste0("Output/apps/sv/",NAME))
