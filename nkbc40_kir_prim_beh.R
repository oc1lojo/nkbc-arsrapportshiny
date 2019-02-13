dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc40_def$sjhkod_var) %>%
  filter(!is.na(region)) %>%
  filter_nkbc40_pop() %>%
  mutate_nkbc40_outcome() %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(nkbc40_def$other_vars)
  )

rccShiny(
  data = dftemp,
  folder = nkbc40_def$code,
  path = output_path,
  outcomeTitle = nkbc40_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc40_def),
  description = compile_description(nkbc40_def, report_end_year),
  varOther = compile_varOther(nkbc40_def),
  targetValues = nkbc40_def$target_values
)
