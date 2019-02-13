dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc10_def$sjhkod_var) %>%
  filter(!is.na(region)) %>%
  filter_nkbc10_pop() %>%
  mutate_nkbc10_outcome() %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(nkbc10_def$other_vars)
  )
rccShiny(
  data = dftemp,
  folder = nkbc10_def$code,
  path = output_path,
  outcomeTitle = nkbc10_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc10_def),
  description = compile_description(nkbc10_def, report_end_year),
  varOther = compile_varOther(nkbc10_def),
  targetValues = nkbc10_def$target_values
)
