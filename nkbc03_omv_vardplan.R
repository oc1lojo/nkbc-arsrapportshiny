NAME <- "nkbc03"

GLOBALS <- defGlobals(
  LAB = "Individuell vårdplan (Min Vårdplan) har upprättats i samråd med patienten",
  POP = "alla anmälda fall.",
  SHORTLAB = "Min vårdplan",
  SJHKODUSE = "a_inr_sjhkod",
  TARGET = c(80, 95)
)

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    # Hantera missing
    outcome = as.logical(ifelse(a_omv_indivplan_Värde %in% c(0, 1), a_omv_indivplan_Värde, NA))
  ) %>%
  filter(
    # min vp tillkom mitten av 2014
    period >= 2015,

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
      "En individuell skriftlig vårdplan, kallad Min vårdplan, ska tas fram för varje patient med cancer enligt den  Nationella Cancerstrategin (SOU 2009:11).",
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

cat(link, fill = TRUE)
# runApp(paste0("Output/apps/sv/",NAME))
