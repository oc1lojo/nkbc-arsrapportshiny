dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc11_def$sjhkod_var) %>%
  filter(!is.na(region)) %>%
  filter_nkbc11_pop() %>%
  mutate_nkbc11_outcome() %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(nkbc11_def$other_vars)
  )
rccShiny(
  data = dftemp,
  folder = nkbc11_def$code,
  path = output_path,
  outcomeTitle = nkbc11_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc11_def),
  description = compile_description(nkbc11_def, report_end_year),
  varOther = compile_varOther(nkbc11_def),
  targetValues = nkbc11_def$target_values
)
