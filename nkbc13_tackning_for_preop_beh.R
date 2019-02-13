nkbc13_def <- list(
  code = "nkbc13",
  lab = "Täckningsgrad för rapportering av preoperativ onkologisk behandling",
  pop = "opererade fall utan fjärrmetastaser vid diagnos med preoperativ onkologisk behandling",
  pop_short = "fall utan fjärrmetastaser vid diagnos med preoperativ onkologisk behandling",
  target_values = c(70, 85),
  sjhkod_var = "d_onkpreans_sjhkod",
  om_indikatorn = "Rapportering av given onkologisk behandling sker på ett eget formulär till kvalitetsregistret, separat från anmälan. Rapporteringen sker cirka 1 - 1,5 år efter anmälan.",
  vid_tolkning = NULL,
  inkl_beskr_onk_beh = TRUE,
  teknisk_beskrivning = NULL
)

dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc13_def$sjhkod_var) %>%
  mutate(
    outcome = ifelse(!is.na(pre_inr_dat) | !is.na(pre_inr_enh) | !is.na(pre_inr_initav), TRUE, FALSE)
  ) %>%
  filter(
    # Reg av given onkologisk behandling
    period >= 2012,

    # ett år bakåt då info från onk behandling blanketter
    period <= report_end_year - 1,

    # Endast opererade
    !is.na(op_kir_dat),

    # Endast preoponk behandling (planerad om utförd ej finns)
    d_prim_beh_Värde == 2,

    # Ej fjärrmetastaser vid diagnos
    !a_tnm_mklass_Värde %in% 10,

    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder)

rccShiny(
  data = dftemp,
  folder = nkbc13_def$code,
  path = output_path,
  outcomeTitle = nkbc13_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc13_def),
  description = compile_description(nkbc13_def, report_end_year),
  varOther = compile_varOther(nkbc13_def),
  targetValues = nkbc13_def$target_values
)
