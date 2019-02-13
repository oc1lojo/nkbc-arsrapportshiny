dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc22_def$sjhkod_var) %>%
  mutate(
    outcome = as.numeric(ymd(post_kemo_dat) - ymd(op_kir_dat)),
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
  folder = nkbc22_def$code,
  path = output_path,
  outcomeTitle = nkbc22_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc22_def),
  description = compile_description(nkbc22_def, report_end_year),
  varOther = compile_varOther(nkbc22_def),
  propWithinValue = nkbc22_def$prop_within_value,
  targetValues = nkbc22_def$target_values
)
