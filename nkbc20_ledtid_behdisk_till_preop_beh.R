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
