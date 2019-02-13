dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc28_def$sjhkod_var) %>%
  filter(!is.na(region)) %>%
  filter_nkbc28_pop() %>%
  mutate_nkbc28_outcome() %>%
  filter(
    # ett år bakåt då info från onk behandling blanketter
    period <= report_end_year - 1
  ) %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(nkbc28_def$other_vars)
  )


rccShiny(
  data = dftemp,
  folder = nkbc28_def$code,
  path = output_path,
  outcomeTitle = nkbc28_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc28_def),
  description = compile_description(nkbc28_def, report_end_year),
  varOther = compile_varOther(nkbc28_def),
  targetValues = nkbc28_def$target_values
)
