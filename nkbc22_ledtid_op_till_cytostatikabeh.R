dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc22_def$sjhkod_var) %>%
  filter(!is.na(region)) %>%
  filter_nkbc22_pop() %>%
  mutate_nkbc22_outcome() %>%
  filter(
    # ett år bakåt då info från onk behandling blanketter
    period <= report_end_year - 1
  ) %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(nkbc22_def$other_vars)
  )

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
