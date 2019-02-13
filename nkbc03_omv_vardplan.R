dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc03_def$sjhkod_var) %>%
  filter(!is.na(region)) %>%
  filter_nkbc03_pop() %>%
  mutate_nkbc03_outcome() %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(nkbc03_def$other_vars)
  )

rccShiny(
  data = dftemp,
  folder = nkbc03_def$code,
  path = output_path,
  outcomeTitle = nkbc03_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc03_def),
  description = compile_description(nkbc03_def, report_end_year),
  varOther = compile_varOther(nkbc03_def),
  targetValues = nkbc03_def$target_values
)
