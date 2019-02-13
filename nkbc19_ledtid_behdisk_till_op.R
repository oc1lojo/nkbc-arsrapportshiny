dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc19_def$sjhkod_var) %>%
  filter(!is.na(region)) %>%
  filter_nkbc19_pop() %>%
  mutate_nkbc19_outcome() %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(nkbc19_def$other_vars)
  )

rccShiny(
  data = dftemp,
  folder = nkbc19_def$code,
  path = output_path,
  outcomeTitle = nkbc19_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc19_def),
  description = compile_description(nkbc19_def, report_end_year),
  varOther = compile_varOther(nkbc19_def),
  propWithinValue = nkbc19_def$prop_within_value,
  targetValues = nkbc19_def$target_values
)
