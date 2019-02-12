GLOBALS <- defGlobals(
  LAB = "Välgrundad misstanke om cancer till operation",
  POP = "primärt opererade fall utan fjärrmetastaser vid diagnos.",
  SJHKODUSE = "op_inr_sjhkod",
  TARGET = c(80)
)

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    d_a_diag_misscadat = ymd(coalesce(a_diag_misscadat, a_diag_kontdat)),
    outcome = as.numeric(ymd(op_kir_dat) - d_a_diag_misscadat),
    outcome = ifelse(outcome < 0, 0, outcome)
  ) %>%
  filter(
    # Endast fall med år från 2013 (1:a kontakt tillkom 2013)
    period >= 2013,

    # Endast opererade
    !is.na(op_kir_dat),

    # Endast primär opereration (planerad om utförd ej finns)
    d_prim_beh_Värde == 1,

    # Ej fjärrmetastaser vid diagnos
    !a_tnm_mklass_Värde %in% 10,

    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder, d_invasiv)

rccShiny(
  data = dftemp,
  folder = "nkbc15",
  path = OUTPUTPATH,
  outcomeTitle = GLOBALS$LAB,
  folderLinkText = GLOBALS$SHORTLAB,
  geoUnitsPatient = FALSE,
  textBeforeSubtitle = GLOBALS$SHORTPOP,
  description = c(
    paste(
      paste(
        "Standardiserat vårdförlopp infördes 2016 för att säkra utredning och start av behandling till patienter i rimlig tid.",
        "För bröstcancer är tiden från välgrundad misstanke till start av behandling 28 kalenderdagar.",
        "Av patienter som utreds för cancer bör 80% ha gjort det inom denna tidsperiod.",
        "För ett antal patienter krävs mer avancerade utredningsmetoder för att nå diagnos vilket kan förlänga tiden till behandlingsstart.",
        "Startpunkten för SVF har tolkats olika av vårdgivare vilket ger upphov till variation varför ledtiden skall tolkas med stor försiktighet"
      ),
      descTarg(),
      sep = str_sep_description
    ),
    paste0(
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
  propWithinValue = 28,
  targetValues = GLOBALS$TARGET
)
