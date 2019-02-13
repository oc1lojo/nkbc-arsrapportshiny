dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc09d_def$sjhkod_var) %>%
  filter(!is.na(region)) %>%
  filter_nkbc09d_pop() %>%
  mutate_nkbc09d_outcome() %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(nkbc09d_def$other_vars)
  )

rccShiny(
  data = dftemp,
  folder = nkbc09d_def$code,
  path = output_path,
  outcomeTitle = nkbc09d_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc09d_def),
  description = compile_description(nkbc09d_def, report_end_year),
  varOther = compile_varOther(nkbc09d_def),
  targetValues = nkbc09d_def$target_values
)
