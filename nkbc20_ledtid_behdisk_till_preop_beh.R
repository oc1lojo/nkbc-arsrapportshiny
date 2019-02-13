nkbc20_def <- list(
  code = "nkbc20",
  lab = "Första behandlingsdiskussion till preoperativ onkologisk behandling",
  pop = "opererade fall utan fjärrmetastaser vid diagnos med preoperativ onkologisk behandling",
  prop_within_value = 14,
  target_values = c(75, 90),
  sjhkod_var = "pre_inr_sjhkod",
  other_vars = c("a_pat_alder", "d_invasiv"),
  om_indikatorn =
    c(
      "I preoperativ onkologisk behandling ingår cytostatika, strålning eller endokrin behandling.",
      "Standardiserat vårdförlopp infördes 2016 för att säkra utredning och vård till patienter i rimlig och säker tid."
    ),
  vid_tolkning =
    paste(
      "Andelen preoperativt behandlade patienter varierar i landet och före start av behandling görs flera undersökningar som kan förlänga tiden till start.",
      "Många patienter som startar preoperativ onkologisk behandling ingår i behandlingsstudier där vissa undersökningar är obligatoriska som annars hade gjorts senare.",
      "Siffrorna skall därför tolkas med viss försiktighet."
    ),
  teknisk_beskrivning = NULL
)

dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc20_def$sjhkod_var) %>%
  mutate(
    d_pre_onk_dat = pmin(as.Date(pre_kemo_dat),
      as.Date(pre_rt_dat),
      as.Date(pre_endo_dat),
      na.rm = TRUE
    ),

    outcome = as.numeric(ymd(d_pre_onk_dat) - ymd(a_planbeh_infopatdat)),
    outcome = ifelse(outcome < 0, 0, outcome)
  ) %>%
  filter(
    # Reg av given onkologisk behandling
    period >= 2012,

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
  folder = nkbc20_def$code,
  path = output_path,
  outcomeTitle = nkbc20_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc20_def),
  description = compile_description(nkbc20_def, report_end_year),
  varOther = compile_varOther(nkbc20_def),
  propWithinValue = nkbc20_def$prop_within_value,
  targetValues = nkbc20_def$target_values
)
