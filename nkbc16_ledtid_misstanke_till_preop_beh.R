nkbc16_def <- list(
  code = "nkbc16",
  lab = "Välgrundad misstanke om cancer till preoperativ onkologisk behandling",
  pop = "opererade fall utan fjärrmetastaser vid diagnos med preoperativ onkologisk behandling.",
  prop_within_value = 28,
  target_values = c(75, 90),
  sjhkod_var = "pre_inr_sjhkod",
  other_vars = c("a_pat_alder", "d_invasiv"),
  om_indikatorn =
    c(
      "I preoperativ onkologisk behandling ingår cytostatika, strålning eller endokrin behandling.",
      "Standardiserat vårdförlopp infördes 2016 för att säkra utredning och vård till patienter i rimlig och säker tid."
    ),
  vid_tolkning =
    c(
      "Startpunkten för SVF har tolkats olika av vårdgivare vilket ger upphov till variation varför ledtiden skall tolkas med försiktighet.",
      paste(
        "Andelen preoperativt behandlade patienter varierar i landet och före start av behandling görs flera undersökningar som kan förlänga tiden till start.",
        "Många patienter som startar preoperativ onkologisk behandling ingår i behandlingsstudier där vissa undersökningar är obligatoriska som annars hade gjorts senare.",
        "Siffrorna skall därför tolkas med viss försiktighet."
      )
    ),
  inkl_beskr_missca = TRUE,
  teknisk_beskrivning = NULL
)

dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc16_def$sjhkod_var) %>%
  mutate(
    d_a_diag_misscadat = ymd(coalesce(a_diag_misscadat, a_diag_kontdat)),
    d_pre_onk_dat = pmin(ymd(pre_kemo_dat),
      ymd(pre_rt_dat),
      ymd(pre_endo_dat),
      na.rm = TRUE
    ),

    outcome = as.numeric(ymd(d_pre_onk_dat) - d_a_diag_misscadat),

    outcome = ifelse(outcome < 0, 0, outcome)
  ) %>%
  filter(
    # Endast fall med år från 2013 (1:a kontakt tillkom 2013)
    period >= 2013,

    # ett år bakåt då info från onk behandling blanketter
    period <= report_end_year - 1,

    # Endast opererade
    !is.na(op_kir_dat),

    # Endast preop onk behandling (planerad om utförd ej finns)
    d_prim_beh_Värde == 2,

    # Ej fjärrmetastaser vid diagnos
    !a_tnm_mklass_Värde %in% 10,

    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder, d_invasiv)

rccShiny(
  data = dftemp,
  folder = nkbc16_def$code,
  path = output_path,
  outcomeTitle = nkbc16_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc16_def),
  description = compile_description(nkbc16_def, report_end_year),
  varOther = compile_varOther(nkbc16_def),
  propWithinValue = nkbc16_def$prop_within_value,
  targetValues = nkbc16_def$target_values
)
