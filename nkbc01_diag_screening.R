dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc01_def$sjhkod_var) %>%
  filter(!is.na(region)) %>%
  filter_nkbc01_pop() %>%
  mutate_nkbc01_outcome() %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(nkbc01_def$other_vars)
  )

rccShiny(
  data = dftemp,
  folder = nkbc01_def$code,
  path = output_path,
  outcomeTitle = nkbc01_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc01_def),
  description = compile_description(nkbc01_def, report_end_year),
  varOther = compile_varOther(nkbc01_def),
  targetValues = nkbc01_def$target_values
)
