dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc06_def$sjhkod_var) %>%
  filter(!is.na(region)) %>%
  filter_nkbc06_pop() %>%
  mutate_nkbc06_outcome() %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(nkbc06_def$other_vars)
  )

rccShiny(
  data = dftemp,
  folder = nkbc06_def$code,
  path = output_path,
  outcomeTitle = nkbc06_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc06_def),
  description = compile_description(nkbc06_def, report_end_year),
  varOther = compile_varOther(nkbc06_def),
  targetValues = nkbc06_def$target_values
)
