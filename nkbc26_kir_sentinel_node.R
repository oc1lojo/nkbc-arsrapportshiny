dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc26_def$sjhkod_var) %>%
  filter(!is.na(region)) %>%
  filter_nkbc26_pop() %>%
  mutate_nkbc26_outcome() %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(nkbc26_def$other_vars)
  )

rccShiny(
  data = dftemp,
  folder = nkbc26_def$code,
  path = output_path,
  outcomeTitle = nkbc26_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc26_def),
  description = compile_description(nkbc26_def, report_end_year),
  varOther = compile_varOther(nkbc26_def),
  targetValues = nkbc26_def$target_values
)
