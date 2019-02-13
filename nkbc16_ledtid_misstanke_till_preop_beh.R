dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc16_def$sjhkod_var) %>%
  filter(!is.na(region)) %>%
  filter_nkbc16_pop() %>%
  mutate_nkbc16_outcome() %>%
  filter(
    # ett år bakåt då info från onk behandling blanketter
    period <= report_end_year - 1
  ) %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(nkbc16_def$other_vars)
  )

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
