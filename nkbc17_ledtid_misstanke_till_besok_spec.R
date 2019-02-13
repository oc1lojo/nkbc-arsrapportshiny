dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc17_def$sjhkod_var) %>%
  filter(!is.na(region)) %>%
  filter_nkbc17_pop() %>%
  mutate_nkbc17_outcome() %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(nkbc17_def$other_vars)
  )
rccShiny(
  data = dftemp,
  folder = nkbc17_def$code,
  path = output_path,
  outcomeTitle = nkbc17_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc17_def),
  description = compile_description(nkbc17_def, report_end_year),
  varOther = compile_varOther(nkbc17_def),
  propWithinValue = nkbc17_def$prop_within_value,
  targetValues = nkbc17_def$target_values
)
