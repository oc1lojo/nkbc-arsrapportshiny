dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc04_def$sjhkod_var) %>%
  filter(!is.na(region)) %>%
  filter_nkbc04_pop() %>%
  mutate_nkbc04_outcome() %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(nkbc04_def$other_vars)
  )
rccShiny(
  data = dftemp,
  folder = nkbc04_def$code,
  path = output_path,
  outcomeTitle = nkbc04_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc04_def),
  description = compile_description(nkbc04_def, report_end_year),
  varOther = compile_varOther(nkbc04_def),
  targetValues = nkbc04_def$target_values
)
