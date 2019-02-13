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
