dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc15)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc15_pop() %>%
  mutate_nkbc15_outcome() %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(other_vars(nkbc15))
  )

rccShiny(
  data = dftemp,
  folder = code(nkbc15),
  path = output_path,
  outcomeTitle = lab(nkbc15),
  textBeforeSubtitle = textBeforeSubtitle(nkbc15),
  description = description(nkbc15, report_end_year),
  varOther = varOther(nkbc15),
  propWithinValue = nkbc15$prop_within_value,
  targetValues = target_values(nkbc15)
)
