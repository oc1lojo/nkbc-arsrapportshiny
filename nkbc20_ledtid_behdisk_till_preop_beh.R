dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc20_def$sjhkod_var) %>%
  filter(!is.na(region)) %>%
  filter_nkbc20_pop() %>%
  mutate_nkbc20_outcome() %>%
  filter(
    # ett år bakåt då info från onk behandling blanketter
    period <= report_end_year - 1
  ) %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(nkbc20_def$other_vars)
  )

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
