dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc02_def$sjhkod_var) %>%
  filter(!is.na(region)) %>%
  filter_nkbc02_pop() %>%
  mutate_nkbc02_outcome() %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(nkbc02_def$other_vars)
  )

rccShiny(
  data = dftemp,
  folder = nkbc02_def$code,
  path = output_path,
  outcomeTitle = nkbc02_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc02_def),
  description = compile_description(nkbc02_def, report_end_year),
  varOther = compile_varOther(nkbc02_def),
  targetValues = nkbc02_def$target_values
)
