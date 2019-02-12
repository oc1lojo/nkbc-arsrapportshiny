GLOBALS <- defGlobals(
  LAB = "Spridning till lymfkörtlarna (klinisk) vid diagnos",
  SHORTLAB = "Spridning till lymfkörtlarna",
  POP = "alla anmälda fall.",
  SJHKODUSE = "a_inr_sjhkod"
)

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    outcome = d_nstad
  ) %>%
  filter(
    # Endast invasiv cancer
    # invasiv == "Invasiv cancer", Bortselekterat pga om väljer enbart invasiv
    # cancer så tas alla med uppgift saknas på invasiv bort. Dock några fel? reg
    # in situ och N1 men men...

    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder)

rccShiny(
  data = dftemp,
  folder = "nkbc09e",
  path = OUTPUTPATH,
  outcomeTitle = GLOBALS$LAB,
  folderLinkText = GLOBALS$SHORTLAB,
  geoUnitsPatient = FALSE,
  textBeforeSubtitle = GLOBALS$SHORTPOP,
  description = c(
    "Kännedom om tumörspridning till axillens lymfkörtlar ger vägledning för behandling och information om prognos. Grundas på bilddiagnostik och klinisk undersökning.",
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
      var = "a_pat_alder",
      label = c("Ålder vid diagnos")
    )
  )
)
