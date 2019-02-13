dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc13_def$sjhkod_var) %>%
  filter(!is.na(region)) %>%
  filter_nkbc13_pop() %>%
  mutate_nkbc13_outcome() %>%
  filter(
    # ett år bakåt då info från onk behandling blanketter
    period <= report_end_year - 1
  ) %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(nkbc13_def$other_vars)
  )

rccShiny(
  data = dftemp,
  folder = nkbc13_def$code,
  path = output_path,
  outcomeTitle = nkbc13_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc13_def),
  description = compile_description(nkbc13_def, report_end_year),
  varOther = compile_varOther(nkbc13_def),
  targetValues = nkbc13_def$target_values
)
