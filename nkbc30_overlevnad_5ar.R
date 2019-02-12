GLOBALS <- defGlobals(
  LAB = "Observerad 5 års överlevnad",
  POP = "alla anmälda fall.",
  SJHKODUSE = "a_inr_sjhkod",
  TARGET = c(88)
)

dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, GLOBALS$SJHKODUSE) %>%
  mutate(
    lastdate = ymd(paste0(YEAR, "-12-31")),
    surv_time = ymd(VITALSTATUSDATUM_ESTIMAT) - ymd(a_diag_dat),
    outcome = surv_time >= 365.25 * 5
  ) %>%
  filter(
    # 5 års överlevnad så krävs 5 års uppföljning
    period <= YEAR - 5,

    !is.na(region)
  ) %>%
  select(landsting, region, period, outcome, a_pat_alder, d_invasiv, d_subtyp)

rccShiny(
  data = dftemp,
  folder = "nkbc30",
  path = OUTPUTPATH,
  outcomeTitle = GLOBALS$LAB,
  folderLinkText = GLOBALS$SHORTLAB,
  geoUnitsPatient = FALSE,
  textBeforeSubtitle = GLOBALS$SHORTPOP,
  description = c(
    paste(
      paste(
        "Total överlevnad betraktas som det viktigaste utfallsmåttet.",
        "Observerad överlevnad anger de bröstcancerfall som överlevt 5 år efter diagnos.",
        "Dödsorsakerna kan vara andra än bröstcancer."
      ),
      descTarg(),
      sep = str_sep_description
    ),
    paste(
      paste0("Uppgifter som rör 5 års överlevnad redovisas enbart t.o.m. ", YEAR - 5, "."),
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
    ),
    list(
      var = "d_subtyp",
      label = c("Biologisk subtyp")
    )
  ),
  targetValues = GLOBALS$TARGET
)
