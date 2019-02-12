nkbc15_def <- list(
  code = "nkbc15",
  lab = "Välgrundad misstanke om cancer till operation",
  pop = "primärt opererade fall utan fjärrmetastaser vid diagnos",
  prop_within_value = 28,
  target_values = c(80),
  sjhkod_var = "op_inr_sjhkod",
  other_vars = c("a_pat_alder", "d_invasiv"),
  om_indikatorn =
    paste(
      "Standardiserat vårdförlopp infördes 2016 för att säkra utredning och start av behandling till patienter i rimlig tid.",
      "För bröstcancer är tiden från välgrundad misstanke till start av behandling 28 kalenderdagar.",
      "Av patienter som utreds för cancer bör 80% ha gjort det inom denna tidsperiod.",
      "För ett antal patienter krävs mer avancerade utredningsmetoder för att nå diagnos vilket kan förlänga tiden till behandlingsstart.",
      "Startpunkten för SVF har tolkats olika av vårdgivare vilket ger upphov till variation varför ledtiden skall tolkas med stor försiktighet."
    ),
  vid_tolkning = NULL,
  inkl_beskr_missca = TRUE,
  teknisk_beskrivning = NULL
)

dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc15_def$sjhkod_var) %>%
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
  folder = nkbc15_def$code,
  path = output_path,
  outcomeTitle = nkbc15_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc15_def),
  description = compile_description(nkbc15_def, report_end_year),
  varOther = compile_varOther(nkbc15_def),
  propWithinValue = nkbc15_def$prop_within_value,
  targetValues = nkbc15_def$target_values
)
