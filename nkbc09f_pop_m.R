dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc09f_def$sjhkod_var) %>%
  filter(!is.na(region)) %>%
  filter_nkbc09f_pop() %>%
  mutate_nkbc09f_outcome() %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(nkbc09f_def$other_vars)
  )
rccShiny(
  data = dftemp,
  folder = nkbc09f_def$code,
  path = output_path,
  outcomeTitle = nkbc09f_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc09f_def),
  description = compile_description(nkbc09f_def, report_end_year),
  varOther = compile_varOther(nkbc09f_def),
  targetValues = nkbc09f_def$target_values
)
