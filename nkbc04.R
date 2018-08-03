NAME <- "nkbc04"

# Multidisciplinär konferens inför behandlingstart ------------------------------------------------

GLOBALS <- defGlobals(
  LAB = "Multidisciplinär konferens inför behandlingstart",
  POP = "alla anmälda fall.",
  SJHKODUSE <- "a_inr_sjhkod",
  TARGET = c(90, 99)
)

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    # Hantera missing
    outcome = as.logical(ifelse(a_mdk_Värde %in% c(0, 1), a_mdk_Värde, NA))
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
    paste0(
      "Att definierade specialister och professioner deltar i MDK och formulerar behandlingsrekommendationer har betydelse för vårdprocess för jämlik vård, kunskapsstyrd vård och för kvalitetssäkring.",
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
