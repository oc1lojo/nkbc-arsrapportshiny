dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc07_def$sjhkod_var) %>%
  filter(!is.na(region)) %>%
  filter_nkbc07_pop() %>%
  mutate_nkbc07_outcome() %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(nkbc07_def$other_vars)
  )
rccShiny(
  data = dftemp,
  folder = nkbc07_def$code,
  path = output_path,
  outcomeTitle = nkbc07_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc07_def),
  description = compile_description(nkbc07_def, report_end_year),
  varOther = compile_varOther(nkbc07_def),
  targetValues = nkbc07_def$target_values
)
