dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc29_def$sjhkod_var) %>%
  filter(!is.na(region)) %>%
  filter_nkbc29_pop() %>%
  mutate_nkbc29_outcome() %>%
  filter(
    # ett år bakåt då info från onk behandling blanketter
    period <= report_end_year - 1
  ) %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(nkbc29_def$other_vars)
  )


rccShiny(
  data = dftemp,
  folder = nkbc29_def$code,
  path = output_path,
  outcomeTitle = nkbc29_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc29_def),
  description = compile_description(nkbc29_def, report_end_year),
  varOther = compile_varOther(nkbc29_def),
  targetValues = nkbc29_def$target_values
)
