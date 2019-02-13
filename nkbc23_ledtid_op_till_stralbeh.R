dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc23_def$sjhkod_var) %>%
  mutate(
    outcome = as.numeric(ymd(post_rt_dat) - ymd(op_kir_dat)),
    outcome = ifelse(outcome < 0, 0, outcome)
  ) %>%
  filter(
    # Reg av given onkologisk behandling
    period >= 2012,

    # ett år bakåt då info från onk behandling blanketter
    period <= report_end_year - 1,

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
  folder = nkbc23_def$code,
  path = output_path,
  outcomeTitle = nkbc23_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc23_def),
  description = compile_description(nkbc23_def, report_end_year),
  varOther = compile_varOther(nkbc23_def),
  propWithinValue = nkbc23_def$prop_within_value,
  targetValues = nkbc23_def$target_values
)
