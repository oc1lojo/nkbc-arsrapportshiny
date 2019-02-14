dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc20)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc20_pop() %>%
  mutate_nkbc20_outcome() %>%
  filter(
    # ett år bakåt då info från onk behandling blanketter
    period <= report_end_year - 1
  ) %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(other_vars(nkbc20))
  )

rccShiny(
  data = dftemp,
  folder = code(nkbc20),
  path = output_path,
  outcomeTitle = lab(nkbc20),
  textBeforeSubtitle = textBeforeSubtitle(nkbc20),
  description = description(nkbc20, report_end_year),
  varOther = varOther(nkbc20),
  propWithinValue = nkbc20$prop_within_value,
  targetValues = target_values(nkbc20)
)
