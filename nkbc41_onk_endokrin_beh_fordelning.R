dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc41_def$sjhkod_var) %>%
  filter(!is.na(region)) %>%
  filter_nkbc41_pop() %>%
  mutate_nkbc41_outcome() %>%
  filter(
    # ett år bakåt då info från onk behandling blanketter
    period <= report_end_year - 1
  ) %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(nkbc41_def$other_vars)
  )

rccShiny(
  data = dftemp,
  folder = nkbc41_def$code,
  path = output_path,
  outcomeTitle = nkbc41_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc41_def),
  description = compile_description(nkbc41_def, report_end_year),
  varOther = compile_varOther(nkbc41_def),
  targetValues = nkbc41_def$target_values
)
