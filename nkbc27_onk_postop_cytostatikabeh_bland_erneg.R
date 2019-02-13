dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc27_def$sjhkod_var) %>%
  filter(!is.na(region)) %>%
  filter_nkbc27_pop() %>%
  mutate_nkbc27_outcome() %>%
  filter(
    # ett år bakåt då info från onk behandling blanketter
    period <= report_end_year - 1
  ) %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(nkbc27_def$other_vars)
  )
rccShiny(
  data = dftemp,
  folder = nkbc27_def$code,
  path = output_path,
  outcomeTitle = nkbc27_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc27_def),
  description = compile_description(nkbc27_def, report_end_year),
  varOther = compile_varOther(nkbc27_def),
  targetValues = nkbc27_def$target_values
)
