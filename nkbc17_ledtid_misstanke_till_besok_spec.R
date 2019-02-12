GLOBALS <- defGlobals(
  LAB = "Välgrundad misstanke om cancer till första besök i specialiserad vård",
  POP = "alla anmälda fall.",
  SJHKODUSE = "a_inr_sjhkod",
  TARGET = c(75, 90)
)

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    d_a_diag_misscadat = ymd(coalesce(a_diag_misscadat, a_diag_kontdat)),
    outcome = as.numeric(ymd(a_diag_besdat) - d_a_diag_misscadat),

    outcome = ifelse(outcome < 0, 0, outcome)
  ) %>%
  filter(
    # Endast fall med år från 2013 (1:a kontakt tillkom 2013)
    period >= 2013,

    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder, d_invasiv)

rccShiny(
  data = dftemp,
  folder = "nkbc17",
  path = OUTPUTPATH,
  outcomeTitle = GLOBALS$LAB,
  folderLinkText = GLOBALS$SHORTLAB,
  geoUnitsPatient = FALSE,
  textBeforeSubtitle = GLOBALS$SHORTPOP,
  description = c(
    paste0(
      "Standardiserat vårdförlopp infördes 2016 för att säkra utredning och vård till patienter i rimlig och säker tid.",
      descTarg(),
      sep = str_sep_description
    ),
    paste0(
      "Startpunkten för SVF har tolkats olika av vårdgivare vilket ger upphov till variation varför ledtiden skall tolkas med försiktighet.",
      MisstCa,
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
  propWithinValue = 7,
  targetValues = GLOBALS$TARGET
)
