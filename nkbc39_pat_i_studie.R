dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc39_def$sjhkod_var) %>%
  filter(!is.na(region)) %>%
  filter_nkbc39_pop() %>%
  mutate_nkbc39_outcome() %>%
  filter(
    # ett år bakåt då info från onk behandling blanketter
    period <= report_end_year - 1
  ) %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(nkbc39_def$other_vars)
  )

rccShiny(
  data = dftemp,
  folder = nkbc39_def$code,
  path = output_path,
  outcomeTitle = nkbc39_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc39_def),
  description = compile_description(nkbc39_def, report_end_year),
  varOther = compile_varOther(nkbc39_def),
  targetValues = nkbc39_def$target_values
)
