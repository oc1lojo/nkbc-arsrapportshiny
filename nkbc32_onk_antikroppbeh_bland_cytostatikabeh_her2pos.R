dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc32_def$sjhkod_var) %>%
  filter(!is.na(region)) %>%
  filter_nkbc32_pop() %>%
  mutate_nkbc32_outcome() %>%
  filter(
    # ett år bakåt då info från onk behandling blanketter
    period <= report_end_year - 1
  ) %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(nkbc32_def$other_vars)
  )

rccShiny(
  data = dftemp,
  folder = nkbc32_def$code,
  path = output_path,
  outcomeTitle = nkbc32_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc32_def),
  description = compile_description(nkbc32_def, report_end_year),
  varOther = compile_varOther(nkbc32_def),
  targetValues = nkbc32_def$target_values
)
