dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc05_def$sjhkod_var) %>%
  filter(!is.na(region)) %>%
  filter_nkbc05_pop() %>%
  mutate_nkbc05_outcome() %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(nkbc05_def$other_vars)
  )

rccShiny(
  data = dftemp,
  folder = nkbc05_def$code,
  path = output_path,
  outcomeTitle = nkbc05_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc05_def),
  description = compile_description(nkbc05_def, report_end_year),
  varOther = compile_varOther(nkbc05_def),
  targetValues = nkbc05_def$target_values
)
