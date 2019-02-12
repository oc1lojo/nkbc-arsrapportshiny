GLOBALS <- defGlobals(
  LAB = "Omedelbara rekonstruktioner vid mastektomi",
  SHORTPOP = "mastektomerade fall utan fjärrmetastaser vid diagnos.",
  POP = "fall med mastektomi eller subkutan mastektomi utan fjärrmetastaser vid diagnos.",
  SJHKODUSE = "op_inr_sjhkod",
  TARGET = c(15, 20)
)

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    # Hantera missing
    outcome = as.logical(ifelse(op_kir_onkoplastik_Värde %in% c(0, 1), op_kir_onkoplastik_Värde, NA))
  ) %>%
  filter(
    # Endast mastektomi och subkutan mastektomi
    op_kir_brost_Värde %in% c(2, 4),

    # Ej fjärrmetastaser vid diagnos
    !a_tnm_mklass_Värde %in% 10,

    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder, d_invasiv)

rccShiny(
  data = dftemp,
  folder = "nkbc07",
  path = OUTPUTPATH,
  outcomeTitle = GLOBALS$LAB,
  folderLinkText = GLOBALS$SHORTLAB,
  geoUnitsPatient = FALSE,
  textBeforeSubtitle = GLOBALS$SHORTPOP,
  description = c(
    paste(
      "Omedelbar rekonstruktion innebär att en bröstform återskapas i samband med att ett helt bröst opereras bort. Bröstrekonstruktion kan göras senare efter avslutad onkologisk behandling.",
      descTarg(),
      sep = str_sep_description
    ),
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
    ),
    list(
      var = "d_invasiv",
      label = c("Invasivitet vid diagnos")
    )
  ),
  targetValues = GLOBALS$TARGET
)
