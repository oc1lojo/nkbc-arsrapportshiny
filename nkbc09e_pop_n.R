dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc09e_def$sjhkod_var) %>%
  filter(!is.na(region)) %>%
  filter_nkbc09e_pop() %>%
  mutate_nkbc09e_outcome() %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(nkbc09e_def$other_vars)
  )

rccShiny(
  data = dftemp,
  folder = nkbc09e_def$code,
  path = output_path,
  outcomeTitle = nkbc09e_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc09e_def),
  description = compile_description(nkbc09e_def, report_end_year),
  varOther = compile_varOther(nkbc09e_def),
  targetValues = nkbc09e_def$target_values
)
