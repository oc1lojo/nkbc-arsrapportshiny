dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc23_def$sjhkod_var) %>%
  filter(!is.na(region)) %>%
  filter_nkbc23_pop() %>%
  mutate_nkbc23_outcome() %>%
  filter(
    # ett år bakåt då info från onk behandling blanketter
    period <= report_end_year - 1
  ) %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(nkbc23_def$other_vars)
  )

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
