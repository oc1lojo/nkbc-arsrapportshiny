dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc35_def$sjhkod_var) %>%
  filter(!is.na(region)) %>%
  filter_nkbc35_pop() %>%
  mutate_nkbc35_outcome() %>%
  filter(
    # ett år bakåt då info från onk behandling blanketter
    period <= report_end_year - 1
  ) %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(nkbc35_def$other_vars)
  )

rccShiny(
  data = dftemp,
  folder = nkbc35_def$code,
  path = output_path,
  outcomeTitle = nkbc35_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc35_def),
  description = compile_description(nkbc35_def, report_end_year),
  varOther = compile_varOther(nkbc35_def),
  targetValues = nkbc35_def$target_values
)
