dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc09a_def$sjhkod_var) %>%
  filter(!is.na(region)) %>%
  filter_nkbc09a_pop() %>%
  mutate_nkbc09a_outcome() %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(nkbc09a_def$other_vars)
  )

rccShiny(
  data = dftemp,
  folder = nkbc09a_def$code,
  path = output_path,
  outcomeTitle = nkbc09a_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc09a_def),
  description = compile_description(nkbc09a_def, report_end_year),
  varOther = compile_varOther(nkbc09a_def),
  targetValues = nkbc09a_def$target_values
)
