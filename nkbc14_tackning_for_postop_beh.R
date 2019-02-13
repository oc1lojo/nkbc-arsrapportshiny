dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc14_def$sjhkod_var) %>%
  filter(!is.na(region)) %>%
  filter_nkbc14_pop() %>%
  mutate_nkbc14_outcome() %>%
  filter(
    # ett år bakåt då info från onk behandling blanketter
    period <= report_end_year - 1
  ) %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(nkbc14_def$other_vars)
  )

rccShiny(
  data = dftemp,
  folder = nkbc14_def$code,
  path = output_path,
  outcomeTitle = nkbc14_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc14_def),
  description = compile_description(nkbc14_def, report_end_year),
  varOther = compile_varOther(nkbc14_def),
  targetValues = nkbc14_def$target_values
)
