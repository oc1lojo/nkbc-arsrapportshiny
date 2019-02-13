dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc15_def$sjhkod_var) %>%
  filter(!is.na(region)) %>%
  filter_nkbc15_pop() %>%
  mutate_nkbc15_outcome() %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(nkbc15_def$other_vars)
  )

rccShiny(
  data = dftemp,
  folder = nkbc15_def$code,
  path = output_path,
  outcomeTitle = nkbc15_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc15_def),
  description = compile_description(nkbc15_def, report_end_year),
  varOther = compile_varOther(nkbc15_def),
  propWithinValue = nkbc15_def$prop_within_value,
  targetValues = nkbc15_def$target_values
)
