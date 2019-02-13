dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc08_def$sjhkod_var) %>%
  filter(!is.na(region)) %>%
  filter_nkbc08_pop() %>%
  mutate_nkbc08_outcome() %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(nkbc08_def$other_vars)
  )

rccShiny(
  data = dftemp,
  folder = nkbc08_def$code,
  path = output_path,
  outcomeTitle = nkbc08_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc08_def),
  description = compile_description(nkbc08_def, report_end_year),
  varOther = compile_varOther(nkbc08_def),
  targetValues = nkbc08_def$target_values
)
