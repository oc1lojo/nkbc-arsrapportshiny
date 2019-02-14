dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc14)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc14_pop() %>%
  mutate_nkbc14_outcome() %>%
  filter(
    # ett år bakåt då info från onk behandling blanketter
    period <= report_end_year - 1
  ) %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(other_vars(nkbc14))
  )

rccShiny(
  data = dftemp,
  folder = code(nkbc14),
  path = output_path,
  outcomeTitle = lab(nkbc14),
  textBeforeSubtitle = textBeforeSubtitle(nkbc14),
  description = description(nkbc14, report_end_year),
  varOther = varOther(nkbc14),
  targetValues = target_values(nkbc14)
)
