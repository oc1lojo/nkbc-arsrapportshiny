dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc31_def$sjhkod_var) %>%
  filter(!is.na(region)) %>%
  filter_nkbc31_pop() %>%
  mutate_nkbc31_outcome() %>%
  filter(
    # ett år bakåt då info från onk behandling blanketter
    period <= report_end_year - 1
  ) %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(nkbc31_def$other_vars)
  )

rccShiny(
  data = dftemp,
  folder = nkbc31_def$code,
  path = output_path,
  outcomeTitle = nkbc31_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc31_def),
  description = compile_description(nkbc31_def, report_end_year),
  varOther = compile_varOther(nkbc31_def),
  targetValues = nkbc31_def$target_values
)
