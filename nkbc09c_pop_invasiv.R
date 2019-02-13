dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc09c_def$sjhkod_var) %>%
  filter(!is.na(region)) %>%
  filter_nkbc09c_pop() %>%
  mutate_nkbc09c_outcome() %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(nkbc09c_def$other_vars)
  )

rccShiny(
  data = dftemp,
  folder = nkbc09c_def$code,
  path = output_path,
  outcomeTitle = nkbc09c_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc09c_def),
  description = compile_description(nkbc09c_def, report_end_year),
  varOther = compile_varOther(nkbc09c_def),
  targetValues = nkbc09c_def$target_values
)
