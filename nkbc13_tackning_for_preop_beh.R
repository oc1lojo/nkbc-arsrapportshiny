dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc13)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc13_pop() %>%
  mutate_nkbc13_outcome() %>%
  filter(
    # ett år bakåt då info från onk behandling blanketter
    period <= report_end_year - 1
  ) %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(other_vars(nkbc13))
  )

rccShiny(
  data = dftemp,
  folder = code(nkbc13),
  path = output_path,
  outcomeTitle = lab(nkbc13),
  textBeforeSubtitle = textBeforeSubtitle(nkbc13),
  description = description(nkbc13, report_end_year),
  varOther = varOther(nkbc13),
  targetValues = target_values(nkbc13)
)
