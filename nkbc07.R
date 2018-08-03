NAME <- "nkbc07"

# Omedelbara rekonstruktioner vid mastektomi ------------------------------------------------

GLOBALS <- defGlobals(
  LAB = "Omedelbara rekonstruktioner vid mastektomi",
  SHORTPOP = "mastektomerade fall utan fjärrmetastaser vid diagnos.",
  POP = "fall med mastektomi eller subkutan mastektomi utan fjärrmetastaser vid diagnos.",
  SJHKODUSE <- "op_inr_sjhkod",
  TARGET = c(15, 20)
)

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    # Hantera missing
    outcome = as.logical(ifelse(op_kir_dirrek_Värde %in% c(0, 1), op_kir_dirrek_Värde, NA))
  ) %>%
  filter(
    # Endast mastektomi och subkutan mastektomi
    op_kir_brost_Värde %in% c(2, 4),

    # Ej fjärrmetastaser vid diagnos
    !a_tnm_mklass_Värde %in% 10,

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
    paste0(
      "Omedelbar rekonstruktion innebär att en bröstform återskapas i samband med att ett helt bröst opereras bort. Bröstrekonstruktion kan göras senare efter avslutad onkologisk behandling.",
      descTarg()
    ),
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
  ),
  targetValues = GLOBALS$TARGET
)

cat(link)
# runApp(paste0("Output/apps/sv/",NAME))
