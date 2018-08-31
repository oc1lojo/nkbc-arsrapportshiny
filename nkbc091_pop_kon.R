NAME <- "nkbc091"

GLOBALS <- defGlobals(
  LAB = "Kön vid diagnos",
  SHORTLAB = "Kön",
  POP = "alla anmälda fall.",
  SJHKODUSE = "a_inr_sjhkod"
)

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    outcome = factor(KON_VALUE,
      levels = c(1, 2),
      labels = c("Män", "Kvinnor")
    )
  ) %>%
  filter(
    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder, invasiv)

link <- rccShiny(
  data = dftemp,
  folder = NAME,
  path = OUTPUTPATH,
  outcomeTitle = GLOBALS$LAB,
  folderLinkText = GLOBALS$SHORTLAB,
  geoUnitsPatient = FALSE,
  textBeforeSubtitle = GLOBALS$SHORTPOP,
  description = c(
    "Bröstcancer drabbar både män och kvinnor.",
    descTolk,
    descTekBes()
  ),
  varOther = list(
    list(
      var = "a_pat_alder",
      label = c("Ålder vid diagnos")
    ),
    list(
      var = "invasiv",
      label = c("Invasivitet vid diagnos")
    )
  )
)

cat(link)
# runApp(paste0("Output/apps/sv/",NAME))
